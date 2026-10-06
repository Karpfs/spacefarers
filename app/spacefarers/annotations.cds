using SpacefarerService as service from '../../srv/spacefarer-service';

// Field labels
annotate service.Spacefarers with {
    name                    @title: 'Name';
    email                   @title: 'Email';
    stardustCollection      @title: 'Stardust Collection';
    wormholeNavigationSkill @title: 'Wormhole Navigation Skill';
    originPlanet            @title: 'Origin Planet';
    spacesuitColor          @title: 'Spacesuit Color';
};

annotate service.Spacefarers with @(
    // Object page header
    UI.HeaderInfo        : {
        TypeName      : 'Spacefarer',
        TypeNamePlural: 'Spacefarers',
        Title         : {Value: name},
        Description   : {Value: originPlanet}
    },

    // Filter bar
    UI.SelectionFields   : [
        spacesuitColor,
        stardustCollection
    ],

    // List report columns
    UI.LineItem          : [
        {Value: name},
        {Value: stardustCollection},
        {Value: spacesuitColor},
        {Value: wormholeNavigationSkill},
        {Value: originPlanet}
    ],

    // Object page sections
    UI.Facets            : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'Cosmic Details',
        Target: '@UI.FieldGroup#Cosmic'
    }],
    UI.FieldGroup #Cosmic: {Data: [
        {Value: name},
        {Value: email},
        {Value: stardustCollection},
        {Value: wormholeNavigationSkill},
        {Value: spacesuitColor}
    ]}
);
