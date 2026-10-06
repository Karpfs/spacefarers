using SpacefarerService as service from '../../srv/spacefarer-service';

// Field labels
annotate service.Spacefarers with {
    name                    @title: 'Name';
    email                   @title: 'Email';
    stardustCollection      @title: 'Stardust Collection';
    wormholeNavigationSkill @title: 'Wormhole Navigation Skill';
    originPlanet            @title: 'Origin Planet';
    spacesuitColor          @title: 'Spacesuit Color';
    stardustCriticality     @UI.Hidden;
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
        stardustCollection,
        department_ID
    ],

    // List report columns
    UI.LineItem          : [
        {Value: name},
        {
            Value                    : stardustCollection,
            Criticality              : stardustCriticality,
            CriticalityRepresentation: #WithoutIcon
        },
        {Value: spacesuitColor},
        {Value: wormholeNavigationSkill},
        {Value: originPlanet},
        {Value: department_ID},
        {Value: position_ID}
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
        {Value: spacesuitColor},
        {Value: department_ID},
        {Value: position_ID}
    ]}
);

// Dropdowns for department and position, showing names instead of IDs
annotate service.Spacefarers with {
    department  @title: 'Department'  @Common: {
        Text                    : department.name,
        TextArrangement         : #TextOnly,
        ValueListWithFixedValues: true,
        ValueList               : {
            CollectionPath: 'Departments',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: department_ID,
                ValueListProperty: 'ID'
            }]
        }
    };
    position    @title: 'Position'    @Common: {
        Text                    : position.title,
        TextArrangement         : #TextOnly,
        ValueListWithFixedValues: true,
        ValueList               : {
            CollectionPath: 'Positions',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: position_ID,
                ValueListProperty: 'ID'
            }]
        }
    };
};

annotate service.Departments with {
    ID @Common: {
        Text           : name,
        TextArrangement: #TextOnly
    }
};

annotate service.Positions with {
    ID @Common: {
        Text           : title,
        TextArrangement: #TextOnly
    }
};
