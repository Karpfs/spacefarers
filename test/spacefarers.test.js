const cds = require('@sap/cds');
const { GET, POST, expect, defaults } = cds.test(__dirname + '/..');

// Let the tests assert on the HTTP status themselves
defaults.validateStatus = () => true;

const BASE = '/odata/v4/spacefarer';
const alice = { auth: { username: 'alice', password: 'alice' } }; // Earth
const bob = { auth: { username: 'bob', password: 'bob' } };       // Mars

// Creates a draft and activates it, like the Fiori UI does on "Create"
async function createSpacefarer(data, user) {
    const draft = await POST(`${BASE}/Spacefarers`, data, user);
    return POST(
        `${BASE}/Spacefarers(ID=${draft.data.ID},IsActiveEntity=false)/SpacefarerService.draftActivate`,
        {},
        user
    );
}

describe('SpacefarerService', () => {
    it('rejects unauthenticated requests', async () => {
        const { status } = await GET(`${BASE}/Spacefarers`);
        expect(status).to.equal(401);
    });

    it('shows only spacefarers from the user\'s own planet', async () => {
        const { data } = await GET(`${BASE}/Spacefarers`, alice);
        expect(data.value.length).to.be.greaterThan(0);
        for (const s of data.value) expect(s.originPlanet).to.equal('Earth');
    });

    it('does not let a user read a spacefarer from another planet', async () => {
        const luna = '11111111-1111-1111-1111-111111111111'; // lives on Earth
        const { status } = await GET(`${BASE}/Spacefarers(ID=${luna},IsActiveEntity=true)`, bob);
        expect([403, 404]).to.include(status);
    });

    it('enhances a new spacefarer and assigns the creator\'s planet', async () => {
        const { data } = await createSpacefarer(
            { name: 'Nova Stark', email: 'nova@example.com', stardustCollection: 50, wormholeNavigationSkill: 5 },
            alice
        );
        expect(data.stardustCollection).to.equal(60); // 50 + welcome bonus
        expect(data.originPlanet).to.equal('Earth');
    });

    it('rejects a negative stardust collection', async () => {
        const { status } = await createSpacefarer(
            { name: 'Bad Data', email: 'bad@example.com', stardustCollection: -5, wormholeNavigationSkill: 5 },
            alice
        );
        expect(status).to.equal(400);
    });
});
