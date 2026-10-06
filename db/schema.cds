namespace galactic;
using { cuid, managed } from '@sap/cds/common';

entity Spacefarers : cuid, managed {
  name                    : String(100) @mandatory;
  email                   : String(255) @mandatory;
  stardustCollection      : Integer default 0;
  wormholeNavigationSkill : Integer default 1;
  originPlanet            : String(50);
  spacesuitColor          : String(30);
  department              : Association to Departments;
  position                : Association to Positions;
}

entity Departments : cuid { name  : String(100); }
entity Positions   : cuid { title : String(100); }
