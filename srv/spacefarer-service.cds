using { galactic as db } from '../db/schema';

service SpacefarerService @(requires: 'authenticated-user') {

  @odata.draft.enabled
  @restrict: [{ grant: '*', where: 'originPlanet = $user.planet' }]
  entity Spacefarers as projection on db.Spacefarers;

  @readonly entity Departments as projection on db.Departments;
  @readonly entity Positions   as projection on db.Positions;
}
