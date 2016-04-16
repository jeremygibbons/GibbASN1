grammar asn1;

options {
	backtrack=true;
	memoize=true;
	language=CSharp_v4_0;
}

@lexer::members {
	boolean ignore=true;
}

moduleDefinition :
	moduleIdentifier
	DEFINITIONS_LITERAL
	encodingReferenceDefault
	tagDefault
	extensionDefault
	ASSIGNMENT_OPERATOR
	BEGIN_LITERAL
	moduleBody
	encodingControlSections
	END_LITERAL
				 ;

moduleIdentifier : ModuleReference definitiveIdentification
				 ;

definitiveIdentification :
	( definitiveOID
	| definitiveOIDandIRI) ?
						 ;
	
definitiveOID :
	LEFT_CURLY definitiveObjIdComponentList RIGHT_CURLY
		;
		
definitiveOIDandIRI : definitiveOID iRIValue
					;

definitiveObjIdComponentList :
	definitiveObjIdComponent
	| definitiveObjIdComponent definitiveObjIdComponentList
							 ;

definitiveObjIdComponent :
	nameForm
	| definitiveNumberForm
	| definitiveNameAndNumberForm
						 ;

definitiveNumberForm : Number
					 ;

definitiveNameAndNumberForm : Identifier LEFT_PAREN definitiveNumberForm RIGHT_PAREN
;

encodingReferenceDefault :
	(EncodingReference INSTRUCTIONS_LITERAL) ?
						 ;

tagDefault :
	(EXPLICIT_LITERAL TAGS_LITERAL
	| IMPLICIT_LITERAL TAGS_LITERAL
	| AUTOMATIC_LITERAL TAGS_LITERAL ) ?
		   ;

extensionDefault :
	(EXTENSIBILITY_LITERAL IMPLIED_LITERAL) ?
				 ;

moduleBody :
	(exports imports assignmentList) ?
		   ;

exports :
	(EXPORTS_LITERAL symbolsExported SEMI_COLON
	| EXPORTS_LITERAL ALL_LITERAL SEMI_COLON) ?
;

symbolsExported :
	symbolList ?
				;

imports :
	(IMPORTS_LITERAL symbolsImported SEMI_COLON)?
		;

symbolsImported :
	symbolsFromModuleList ?
				;

symbolsFromModuleList :
	symbolsFromModule
	| symbolsFromModuleList symbolsFromModule
					  ;

symbolsFromModule :
	symbolList FROM_LITERAL globalModuleReference
				  ;

globalModuleReference :
	ModuleReference assignedIdentifier
					  ;

assignedIdentifier :
	(objectIdentifierValue
	| definedValue)?
				   ;

symbolList :
	symbol
	| symbolList COMMA symbol
		   ;

symbol :
	reference
	| parameterizedReference
	   ;

reference :
	(TypeReference
	| ValueReference
	| ObjectClassReference
	| ObjectReference
	| ObjectSetReference)
		  ;

assignmentList :
	assignment
	| assignmentList assignment
			   ;

assignment :
	typeAssignment
	| valueAssignment
	| xMLValueAssignment
	| valueSetTypeAssignment
	| objectClassAssignment
	| objectAssignment
	| objectSetAssignment
	| parameterizedAssignment
		   ;

definedType :
	externalTypeReference
	| TypeReference
	| parameterizedType
	| parameterizedValueSetType
			;

definedValue :
	externalValueReference
	| ValueReference
	| parameterizedValue
			 ;

nonParameterizedTypeName :
	externalTypeReference
	| TypeReference
	| xmlasn1typename
						 ;
		
externalTypeReference : ModuleReference DOT TypeReference
					  ;

externalValueReference : ModuleReference DOT ValueReference
					   ;

absoluteReference : AT moduleIdentifier DOT itemSpec
				  ;

itemSpec :
	TypeReference
	| itemId DOT componentId
		 ;

itemId : itemSpec
	   ;

componentId :
	(Identifier | Number | STAR)
			;

typeAssignment : TypeReference ASSIGNMENT_OPERATOR type
			   ;

valueAssignment : ValueReference type ASSIGNMENT_OPERATOR value
				;

xMLValueAssignment : ValueReference ASSIGNMENT_OPERATOR xMLTypedValue
				   ;

xMLTypedValue :
		{ignore=false;} LESS_THAN  nonParameterizedTypeName {ignore=true;} GREATER_THAN xMLValue {ignore=false;}LESS_THAN_SLASH nonParameterizedTypeName {ignore=true;}GREATER_THAN
	| {ignore=false;} LESS_THAN  nonParameterizedTypeName {ignore=true;}SLASH_GREATER_THAN
			  ;

valueSetTypeAssignment : TypeReference type ASSIGNMENT_OPERATOR valueSet
					   ;

valueSet : LEFT_CURLY elementSetSpecs RIGHT_CURLY
		 ;

type :
	builtinType
	| referencedType
	| constrainedType
	 ;

builtinType :
	bitStringType
	| booleanType
	| characterStringType
	| choiceType
	| dateType
	| dateTimeType
	| durationType
	| embeddedPDVType
	| enumeratedType
	| externalType
	| instanceOfType
	| integerType
	| iRIType
	| nullType
	| objectClassFieldType
	| objectIdentifierType
	| octetStringType
	| realType
	| relativeIRIType
	| relativeOIDType
	| sequenceType
	| sequenceOfType
	| setType
	| setOfType
	| prefixedType
	| timeType
	| timeOfDayType
			;

referencedType :
	definedType
	| usefulType
	| selectionType
	| typeFromObject
	| valueSetFromObjects
			   ;

namedType : Identifier type
		  ;

value :
	builtinValue
	| referencedValue
	| objectClassFieldValue
	  ;
xMLValue :
	xMLBuiltinValue
	| xMLObjectClassFieldValue
		 ;

builtinValue :
	bitStringValue
	| booleanValue
	| characterStringValue
	| choiceValue
	| embeddedPDVValue
	| enumeratedValue
	| externalValue
	| instanceOfValue
	| integerValue
	| iRIValue
	| nullValue
	| objectIdentifierValue
	| octetStringValue
	| realValue
	| relativeIRIValue
	| relativeOIDValue
	| sequenceValue
	| sequenceOfValue
	| setValue
	| setOfValue
	| prefixedValue
	| timeValue
			 ;

xMLBuiltinValue :
	xMLBitStringValue
	| xMLBooleanValue
	| xMLCharacterStringValue
	| xMLChoiceValue
	| xMLEmbeddedPDVValue
	| xMLEnumeratedValue
	| xMLExternalValue
	| xMLInstanceOfValue
	| xMLIntegerValue
	| xMLIRIValue
	| xMLNullValue
	| xMLObjectIdentifierValue
	| xMLOctetStringValue
	| xMLRealValue
	| xMLRelativeIRIValue
	| xMLRelativeOIDValue
	| xMLSequenceValue
	| xMLSequenceOfValue
	| xMLSetValue
	| xMLSetOfValue
	| xMLPrefixedValue
	| xMLTimeValue
				;

referencedValue :
	definedValue
	| valueFromObject
				;

namedValue : Identifier value
		   ;

xMLNamedValue : {ignore=false;} LESS_THAN Identifier {ignore=true;}GREATER_THAN xMLValue {ignore=false;}LESS_THAN_SLASH Identifier {ignore=true;}GREATER_THAN
;

booleanType : BOOLEAN_LITERAL
			;

booleanValue : TRUE_LITERAL | FALSE_LITERAL
			 ;

xMLBooleanValue :
	emptyElementBoolean
	| textBoolean
				;

emptyElementBoolean :
		{ignore=false;}LESS_THAN  TRUE_LOWER SLASH_GREATER_THAN {ignore=true;}
	| {ignore=false;} LESS_THAN FALSE_LOWER SLASH_GREATER_THAN {ignore=true;}
					;

textBoolean :
	ExtendedTrue
	| ExtendedFalse
			;

integerType :
	INTEGER_LITERAL
	| INTEGER_LITERAL LEFT_CURLY namedNumberList RIGHT_CURLY
;

namedNumberList :
	namedNumber
	| namedNumberList COMMA namedNumber
				;

namedNumber :
	Identifier LEFT_PAREN signedNumber RIGHT_PAREN
	| Identifier LEFT_PAREN definedValue RIGHT_PAREN
			;
signedNumber :
	Number
	| HYPHEN Number
			 ;

integerValue :
	SignedNumber
	| Identifier
;


xMLIntegerValue :
	xMLSignedNumber
	| emptyElementInteger
	| textInteger
				;

xMLSignedNumber :
	Number
	| {ignore=false;}HYPHEN Number {ignore=true;}
				;

emptyElementInteger : {ignore=false;} LESS_THAN Identifier {ignore=true;} SLASH_GREATER_THAN
					;

textInteger : Identifier
			;

enumeratedType : ENUMERATED_LITERAL LEFT_CURLY enumerations RIGHT_CURLY
			   ;

enumerations :
	rootEnumeration
	| rootEnumeration COMMA ELLIPSIS exceptionSpec
	| rootEnumeration COMMA ELLIPSIS exceptionSpec COMMA additionalEnumeration
;

rootEnumeration : enumeration
				;

additionalEnumeration : enumeration
					  ;

enumeration :
	enumerationItem
	| enumerationItem COMMA enumeration
			;

enumerationItem :
	Identifier
	| namedNumber
				;

enumeratedValue : Identifier
				;

xMLEnumeratedValue :
	emptyElementEnumerated
	| textEnumerated
				   ;

emptyElementEnumerated : {ignore=false;} LESS_THAN Identifier {ignore=true;} SLASH_GREATER_THAN
					   ;

textEnumerated : Identifier
			   ;

realType : REAL_LITERAL
		 ;

realValue :
	numericRealValue
	| specialRealValue
		  ;

numericRealValue :
	RealNumber
	| HYPHEN RealNumber
	| sequenceValue
				 ;

specialRealValue :
	PLUS_INFINITY_LITERAL
	| MINUS_INFINITY_LITERAL
	| NOT_A_NUMBER_LITERAL
				 ;

xMLRealValue :
	xMLNumericRealValue
	| xMLSpecialRealValue
			 ;

xMLNumericRealValue :
	RealNumber
	| {ignore=false;} HYPHEN RealNumber {ignore=true;}
					;

xMLSpecialRealValue :
	emptyElementReal
	| textReal
					;

emptyElementReal :
	{ignore=false;} LESS_THAN PLUS_INFINITY_LITERAL {ignore=true;} SLASH_GREATER_THAN
	| {ignore=false;} LESS_THAN MINUS_INFINITY_LITERAL {ignore=true;} SLASH_GREATER_THAN
	| {ignore=false;} LESS_THAN NOT_A_NUMBER_LITERAL {ignore=true;} SLASH_GREATER_THAN
				 ;
		
textReal :
	INF_LITERAL
	| {ignore=false;} HYPHEN INF_LITERAL {ignore=true;}
	| NAN_LITERAL
;
bitStringType :
	BIT_LITERAL STRING_LITERAL
	| BIT_LITERAL STRING_LITERAL LEFT_CURLY namedBitList RIGHT_CURLY
			  ;

namedBitList :
	namedBit
	| namedBitList COMMA namedBit
			 ;

namedBit :
	Identifier LEFT_PAREN Number RIGHT_PAREN
	| Identifier LEFT_PAREN definedValue RIGHT_PAREN
;

bitStringValue :
	LEFT_CURLY identifierList RIGHT_CURLY
	| CONTAINING_LITERAL value
		| (BString | HString | (LEFT_CURLY RIGHT_CURLY))
		;
		
identifierList :
	Identifier
	| identifierList COMMA Identifier
;

xMLBitStringValue :
	(xMLTypedValue
	| xmlbstring
	| xMLIdentifierList)?
				  ;

xMLIdentifierList :
	emptyElementList
	| textList
				  ;

emptyElementList :
	{ignore=false;}LESS_THAN Identifier {ignore=true;} SLASH_GREATER_THAN
	| emptyElementList {ignore=false;} LESS_THAN Identifier {ignore=true;} SLASH_GREATER_THAN
				 ;
		
textList :
	Identifier
	| textList Identifier
		 ;

octetStringType : OCTET_LITERAL STRING_LITERAL
				;

octetStringValue :
	(BString | HString)
	| CONTAINING_LITERAL value
				 ;

xMLOctetStringValue :
	xMLTypedValue
	| xmlhstring
					;

nullType : NULL_LITERAL
		 ;

nullValue : NULL_LITERAL
		  ;

xMLNullValue : empty
			 ;

sequenceType :
	SEQUENCE_LITERAL LEFT_CURLY RIGHT_CURLY
	| SEQUENCE_LITERAL LEFT_CURLY extensionAndException optionalExtensionMarker RIGHT_CURLY
	| SEQUENCE_LITERAL LEFT_CURLY componentTypeLists RIGHT_CURLY
			 ;

extensionAndException : ELLIPSIS | ELLIPSIS exceptionSpec
					  ;

optionalExtensionMarker : (COMMA ELLIPSIS)?
						;

componentTypeLists :
	rootComponentTypeList
	| rootComponentTypeList COMMA extensionAndException extensionAdditions optionalExtensionMarker
	| rootComponentTypeList COMMA extensionAndException extensionAdditions extensionEndMarker COMMA rootComponentTypeList
	| extensionAndException extensionAdditions extensionEndMarker COMMA rootComponentTypeList
	| extensionAndException extensionAdditions optionalExtensionMarker
				   ;
rootComponentTypeList : componentTypeList
					  ;

extensionEndMarker : COMMA ELLIPSIS
				   ;

extensionAdditions :
	(COMMA extensionAdditionList)?
				   ;

extensionAdditionList :
	extensionAddition
	| extensionAdditionList COMMA extensionAddition
					  ;

extensionAddition :
	componentType
	| extensionAdditionGroup
				  ;
	
extensionAdditionGroup : DOUBLE_LEFT_BRACKET versionNumber componentTypeList DOUBLE_RIGHT_BRACKET
					   ;

versionNumber : (Number COLON)?
			  ;

componentTypeList :
	componentType
	| componentTypeList COMMA componentType
				  ;

componentType :
	namedType
	| namedType OPTIONAL_LITERAL
	| namedType DEFAULT_LITERAL value
	| COMPONENTS_LITERAL OF_LITERAL type
			  ;

sequenceValue :
	LEFT_CURLY componentValueList RIGHT_CURLY
	| LEFT_CURLY RIGHT_CURLY
		;
		
componentValueList :
	namedValue
	| componentValueList COMMA namedValue
				   ;

xMLSequenceValue :
	xMLComponentValueList ?
				 ;

xMLComponentValueList :
	xMLNamedValue
	| xMLComponentValueList xMLNamedValue
					  ;

sequenceOfType :
	SEQUENCE_LITERAL OF_LITERAL type
	| SEQUENCE_LITERAL OF_LITERAL namedType
			   ;

sequenceOfValue :
	LEFT_CURLY valueList RIGHT_CURLY
	| LEFT_CURLY namedValueList RIGHT_CURLY
	| LEFT_CURLY RIGHT_CURLY
		;
		
valueList :
	value
	| valueList COMMA value
		  ;

namedValueList :
	namedValue
	| namedValueList COMMA namedValue
			   ;

xMLSequenceOfValue :
	(xMLValueList
	| xMLDelimitedItemList)?
				   ;

xMLValueList :
	xMLValueOrEmpty
	| xMLValueOrEmpty xMLValueList
			 ;

xMLValueOrEmpty :
	xMLValue
	| {ignore=false;} LESS_THAN nonParameterizedTypeName {ignore=true;} SLASH_GREATER_THAN
				;

xMLDelimitedItemList :
	xMLDelimitedItem
	| xMLDelimitedItem xMLDelimitedItemList
					 ;

xMLDelimitedItem :
	{ignore=false;} LESS_THAN nonParameterizedTypeName {ignore=true;} GREATER_THAN xMLValue {ignore=false;} LESS_THAN_SLASH nonParameterizedTypeName {ignore=true;} GREATER_THAN
	| {ignore=false;} LESS_THAN Identifier {ignore=true;} GREATER_THAN xMLValue {ignore=false;} LESS_THAN_SLASH Identifier {ignore=true;} GREATER_THAN
				 ;

setType :
	SET_LITERAL LEFT_CURLY RIGHT_CURLY
	| SET_LITERAL LEFT_CURLY extensionAndException optionalExtensionMarker RIGHT_CURLY
	| SET_LITERAL LEFT_CURLY componentTypeLists RIGHT_CURLY
		;

setValue :
	LEFT_CURLY componentValueList RIGHT_CURLY
	| LEFT_CURLY RIGHT_CURLY
		 ;

xMLSetValue :
	xMLComponentValueList ?
			;

setOfType :
	SET_LITERAL OF_LITERAL type
	| SET_LITERAL OF_LITERAL namedType
		  ;

setOfValue :
	LEFT_CURLY valueList RIGHT_CURLY
	| LEFT_CURLY namedValueList RIGHT_CURLY
	| LEFT_CURLY RIGHT_CURLY
		   ;

xMLSetOfValue :
	(xMLValueList
	| xMLDelimitedItemList)?
			  ;

choiceType : CHOICE_LITERAL LEFT_CURLY alternativeTypeLists RIGHT_CURLY
		   ;

alternativeTypeLists :
	rootAlternativeTypeList
	| rootAlternativeTypeList COMMA extensionAndException extensionAdditionAlternatives optionalExtensionMarker
					 ;

rootAlternativeTypeList : alternativeTypeList
						;

extensionAdditionAlternatives :
	(COMMA extensionAdditionAlternativesList)?
							  ;

extensionAdditionAlternativesList :
	extensionAdditionAlternative
	| extensionAdditionAlternativesList COMMA extensionAdditionAlternative
								  ;

extensionAdditionAlternative :
	extensionAdditionAlternativesGroup
	| namedType
							 ;

extensionAdditionAlternativesGroup : DOUBLE_LEFT_BRACKET versionNumber alternativeTypeList DOUBLE_RIGHT_BRACKET
								   ;

alternativeTypeList :
	namedType
	| alternativeTypeList COMMA namedType
					;

choiceValue : Identifier COLON value
			;

xMLChoiceValue : {ignore=false;} LESS_THAN Identifier {ignore=true;} GREATER_THAN xMLValue {ignore=false;} LESS_THAN_SLASH Identifier {ignore=true;} GREATER_THAN
			   ;

selectionType : Identifier LESS_THAN type
			  ;

prefixedType :
	taggedType
	| encodingPrefixedType
			 ;

prefixedValue : value
			  ;

xMLPrefixedValue : xMLValue
				 ;

taggedType :
	tag type
	| tag IMPLICIT_LITERAL type
	| tag EXPLICIT_LITERAL type
		   ;

tag : LEFT_BRACKET encodingReference class classNumber RIGHT_BRACKET
	;

encodingReference :
	(EncodingReference COLON)?
				  ;

classNumber :
	Number
	| definedValue
			;

class :
	(UNIVERSAL_LITERAL
	| APPLICATION_LITERAL
	| PRIVATE_LITERAL)?
	  ;

encodingPrefixedType : encodingPrefix type
					 ;

encodingPrefix : LEFT_BRACKET encodingReference encodingInstruction RIGHT_BRACKET
			   ;

objectIdentifierType : OBJECT_LITERAL IDENTIFIER_LITERAL
					 ;

objectIdentifierValue :
	LEFT_CURLY objIdComponentsList RIGHT_CURLY
	| LEFT_CURLY definedValue objIdComponentsList RIGHT_CURLY
					  ;
		
objIdComponentsList :
	objIdComponents
	| objIdComponents objIdComponentsList
					;
		
objIdComponents :
	nameForm
	| numberForm
	| nameAndNumberForm
	| definedValue
				;
		
nameForm : Identifier
		 ;

numberForm :
	Number
	| definedValue
		   ;

nameAndNumberForm : Identifier LEFT_PAREN numberForm RIGHT_PAREN
				  ;

xMLObjectIdentifierValue : xMLObjIdComponentList
						 ;

xMLObjIdComponentList :
	xMLObjIdComponent
	| {ignore=false;} xMLObjIdComponent DOT xMLObjIdComponentList {ignore=true;}
					  ;

xMLObjIdComponent :
	nameForm
	| xMLNumberForm
	| xMLNameAndNumberForm
				  ;

xMLNumberForm : Number
			  ;

xMLNameAndNumberForm : {ignore=false;} Identifier LEFT_PAREN xMLNumberForm RIGHT_PAREN {ignore=true;}
					 ;

relativeOIDType : RELATIVE_OID_LITERAL
				;

relativeOIDValue : LEFT_CURLY relativeOIDComponentsList RIGHT_CURLY
				 ;

relativeOIDComponentsList :
	relativeOIDComponents
	| relativeOIDComponents relativeOIDComponentsList
						  ;

relativeOIDComponents :
	numberForm
	| nameAndNumberForm
	| definedValue
					  ;

xMLRelativeOIDValue : xMLRelativeOIDComponentList
					;

xMLRelativeOIDComponentList :
	xMLRelativeOIDComponent
	| {ignore=false;} xMLRelativeOIDComponent DOT xMLRelativeOIDComponentList {ignore=true;}
							;

xMLRelativeOIDComponent :
	xMLNumberForm
	| xMLNameAndNumberForm
						;

iRIType : OID_IRI_LITERAL
		;

iRIValue : DOUBLE_QUOTE firstArcIdentifier subsequentArcIdentifier DOUBLE_QUOTE
		 ;

firstArcIdentifier : SLASH arcIdentifier
				   ;

subsequentArcIdentifier :
	(SLASH arcIdentifier subsequentArcIdentifier)?
						;

arcIdentifier :
	IntegerUnicodeLabel
	| nonIntegerUnicodeLabel
			  ;

xMLIRIValue :
	firstArcIdentifier
	subsequentArcIdentifier
			;

relativeIRIType : RELATIVE_OID_IRI_LITERAL
				;

relativeIRIValue : DOUBLE_QUOTE firstRelativeArcIdentifier subsequentArcIdentifier DOUBLE_QUOTE
				 ;

firstRelativeArcIdentifier : arcIdentifier
						   ;

xMLRelativeIRIValue : firstRelativeArcIdentifier subsequentArcIdentifier
					;

embeddedPDVType : EMBEDDED_LITERAL PDV_LITERAL
				;

embeddedPDVValue : sequenceValue
				 ;

xMLEmbeddedPDVValue : xMLSequenceValue
					;

externalType : EXTERNAL_LITERAL
			 ;

externalValue : sequenceValue
			  ;

xMLExternalValue : xMLSequenceValue
				 ;

timeType : TIME_LITERAL
		 ;

timeValue : TString
		  ;

xMLTimeValue : XMLTString
			 ;

dateType : DATE_LITERAL
		 ;

timeOfDayType : TIME_OF_DAY_LITERAL
			  ;

dateTimeType : DATE_TIME_LITERAL
			 ;

durationType : DURATION_LITERAL
			 ;

characterStringType :
	restrictedCharacterStringType
	| unrestrictedCharacterStringType
					;

characterStringValue :
	restrictedCharacterStringValue
	| unrestrictedCharacterStringValue
					 ;

xMLCharacterStringValue :
	xMLRestrictedCharacterStringValue
	| xMLUnrestrictedCharacterStringValue
						;

restrictedCharacterStringType :
	bMPString
	| generalString
	| graphicString
	| iA5String
	| iSO646String
	| numericString
	| printableString
	| teletexString
	| t61String
	| universalString
	| uTF8String
	| videotexString
	| visibleString
							  ;

restrictedCharacterStringValue :
	cstring
	| characterStringList
	| quadruple
	| tuple
							   ;

characterStringList : LEFT_CURLY charSyms RIGHT_CURLY
					;

charSyms :
	charsDefn
	| charSyms COMMA charsDefn
		 ;

charsDefn :
	cstring
	| quadruple
	| tuple
	| definedValue
		  ;

quadruple : LEFT_CURLY group COMMA plane COMMA row COMMA cell RIGHT_CURLY
		  ;

group : Number
	  ;

plane : Number
	  ;

row : Number
	;

cell : Number
	 ;

tuple : LEFT_CURLY tableColumn COMMA tableRow RIGHT_CURLY
	  ;

tableColumn : Number
			;

tableRow : Number
		 ;

xMLRestrictedCharacterStringValue : xmlcstring
								  ;

unrestrictedCharacterStringType : CHARACTER_LITERAL STRING_LITERAL
								;

unrestrictedCharacterStringValue : sequenceValue
								 ;

xMLUnrestrictedCharacterStringValue : xMLSequenceValue
									;

usefulType : TypeReference
		   ;

constrainedType :
	type constraint
	| typeWithConstraint
				;

typeWithConstraint :
	SET_LITERAL constraint OF_LITERAL type
	| SET_LITERAL sizeConstraint OF_LITERAL type
	| SEQUENCE_LITERAL constraint OF_LITERAL type
	| SEQUENCE_LITERAL sizeConstraint OF_LITERAL type
	| SET_LITERAL constraint OF_LITERAL namedType
	| SET_LITERAL sizeConstraint OF_LITERAL namedType
	| SEQUENCE_LITERAL constraint OF_LITERAL namedType
	| SEQUENCE_LITERAL sizeConstraint OF_LITERAL namedType
				   ;

constraint : LEFT_PAREN constraintSpec exceptionSpec RIGHT_PAREN
		   ;

constraintSpec :
	subtypeConstraint
	| generalConstraint
			   ;

subtypeConstraint : elementSetSpecs
				  ;

elementSetSpecs :
	rootElementSetSpec
	| rootElementSetSpec COMMA ELLIPSIS
	| rootElementSetSpec COMMA ELLIPSIS COMMA additionalElementSetSpec
				;

rootElementSetSpec : elementSetSpec
				   ;

additionalElementSetSpec : elementSetSpec
						 ;

elementSetSpec :
	unions
	| ALL_LITERAL exclusions
			   ;

unions :
	intersections
	| uElems unionMark intersections
	   ;

uElems : unions
	   ;

intersections :
	intersectionElements
	| iElems intersectionMark intersectionElements
			  ;

iElems : intersections
	   ;

intersectionElements :
	elements
	| elems exclusions
					 ;

elems : elements
		;
		
exclusions : EXCEPT_LITERAL elements
		;
		
unionMark :
	PIPE
	| UNION_LITERAL
		;
		
intersectionMark :
	CARET
	| INTERSECTION_LITERAL
		;
		
elements :
	subtypeElements
	| objectSetElements
	| LEFT_PAREN elementSetSpec RIGHT_PAREN
		;
		
subtypeElements :
	singleValue
	| containedSubtype
	| valueRange
	| permittedAlphabet
	| sizeConstraint
	| typeConstraint
	| innerTypeConstraints
	| patternConstraint
	| propertySettings
	| durationRange
	| timePointRange
	| recurrenceRange
				;

singleValue : value
			;

containedSubtype : includes type
				 ;

includes :
	INCLUDES_LITERAL ?
		 ;

valueRange : lowerEndpoint RANGE upperEndpoint
		   ;

lowerEndpoint :	
	lowerEndValue
	| lowerEndValue LESS_THAN;

upperEndpoint :
	upperEndValue
	| LESS_THAN upperEndValue
		;
		
lowerEndValue :
	value
	| MIN_LITERAL
		;
		
upperEndValue :
	value
	| MAX_LITERAL
		;
		
sizeConstraint : SIZE_LITERAL constraint
		;
		
typeConstraint : type
		;
		
permittedAlphabet : FROM_LITERAL constraint
		;
		
innerTypeConstraints :
	WITH_LITERAL COMPONENT_LITERAL singleTypeConstraint
	| WITH_LITERAL COMPONENTS_LITERAL multipleTypeConstraints
		;
		
singleTypeConstraint : constraint
		;
		
multipleTypeConstraints :
	fullSpecification
	| partialSpecification
		;
		
fullSpecification : LEFT_CURLY typeConstraints RIGHT_CURLY
		;
		
partialSpecification : LEFT_CURLY ELLIPSIS COMMA typeConstraints RIGHT_CURLY
		;
		
typeConstraints :
	namedConstraint
	| namedConstraint COMMA typeConstraints
		;
		
namedConstraint : Identifier componentConstraint
		;
		
componentConstraint : valueConstraint presenceConstraint
		;
		
valueConstraint : constraint ?
		;
		
presenceConstraint :
	(PRESENT_LITERAL
	| ABSENT_LITERAL
	| OPTIONAL_LITERAL)?
		;
		
patternConstraint : PATTERN_LITERAL value
		;
		
propertySettings : SETTINGS_LITERAL simplestring
		;
		
propertySettingsList :
	propertyAndSettingPair
	| propertySettingsList propertyAndSettingPair
		;
		
propertyAndSettingPair : propertyName EQUALS settingName
		;
		
propertyName : psname
		;
		
settingName : psname
		;
		
durationRange : valueRange
		;
		
timePointRange : valueRange
		;
		
recurrenceRange : valueRange
		;
		
exceptionSpec :
	(EXCLAMATION exceptionIdentification)?
		;
		
exceptionIdentification :
	signedNumber
	| definedValue
	| type COLON value
		;
		
encodingControlSections :
	(encodingControlSection encodingControlSections)?
		;
		
encodingControlSection : ENCODING_CONTROL_LITERAL EncodingReference encodingInstructionAssignmentList
		;

definedObjectClass :
		externalObjectClassReference
		| ObjectClassReference
		| usefulObjectClassReference
				   ;

externalObjectClassReference : ModuleReference DOT ObjectClassReference
							 ;

usefulObjectClassReference :
		TYPE_IDENTIFIER_LITERAL
		| ABSTRACT_SYNTAX_LITERAL
						   ;

objectClassAssignment : ObjectClassReference ASSIGNMENT_OPERATOR objectClass
					  ;

objectClass :
		definedObjectClass
		| objectClassDefn
		| parameterizedObjectClass
			;

objectClassDefn :
		CLASS_LITERAL LEFT_CURLY fieldSpec COMMA + RIGHT_CURLY (withSyntaxSpec)?
				;

fieldSpec :
	typeFieldSpec
	| fixedTypeValueFieldSpec
	| variableTypeValueFieldSpec
	| fixedTypeValueSetFieldSpec
	| variableTypeValueSetFieldSpec
	| objectFieldSpec
	| objectSetFieldSpec
		  ;    

primitiveFieldName :
	TypeFieldReference
	| ValueFieldReference
	| ValueSetFieldReference
	| ObjectFieldReference
	| ObjectSetFieldReference
				   ;

fieldName : primitiveFieldNameList
		  ;

primitiveFieldNameList:
	primitiveFieldName
	| primitiveFieldName DOT primitiveFieldNameList
					  ;

typeFieldSpec : TypeFieldReference (typeOptionalitySpec)?
			  ;

typeOptionalitySpec :
	OPTIONAL_LITERAL
	| DEFAULT_LITERAL type
					;


fixedTypeValueFieldSpec : ValueFieldReference type (UNIQUE_LITERAL)? (valueOptionalitySpec)?
						;

valueOptionalitySpec :
	OPTIONAL_LITERAL
	| DEFAULT_LITERAL value
					 ;

variableTypeValueFieldSpec : ValueFieldReference fieldName (valueOptionalitySpec)?
						   ;

fixedTypeValueSetFieldSpec : ValueSetFieldReference type (valueSetOptionalitySpec)?
						   ;

valueSetOptionalitySpec :
	OPTIONAL_LITERAL
	| DEFAULT_LITERAL valueSet
						;

variableTypeValueSetFieldSpec : ValueSetFieldReference fieldName (valueSetOptionalitySpec)?
							  ;

objectFieldSpec : ObjectFieldReference definedObjectClass (objectOptionalitySpec)?
				;

objectOptionalitySpec :
	OPTIONAL_LITERAL
	| DEFAULT_LITERAL object
					  ;

objectSetFieldSpec : ObjectSetFieldReference definedObjectClass (objectSetOptionalitySpec) ?
				   ;

objectSetOptionalitySpec :
	OPTIONAL_LITERAL
	| DEFAULT_LITERAL objectSet
						 ;
withSyntaxSpec : WITH_LITERAL SYNTAX_LITERAL syntaxList
			   ;

syntaxList : LEFT_CURLY tokenOrGroupSpec empty + RIGHT_CURLY
		   ;

tokenOrGroupSpec :
	requiredToken
	| optionalGroup
				 ;

optionalGroup : LEFT_BRACKET tokenOrGroupSpec empty + RIGHT_BRACKET
			  ;

requiredToken :
	literal
	| primitiveFieldName
			  ;

literal :
	Word
	| COMMA
		;

definedObject :
	externalObjectReference
	| ObjectReference
			  ;

externalObjectReference : ModuleReference DOT ObjectReference
						;

objectAssignment : ObjectReference definedObjectClass ASSIGNMENT_OPERATOR object
				 ;

object :
	definedObject
	| objectDefn
	| objectFromObject
	| parameterizedObject
	   ;

objectDefn :
	defaultSyntax
	| definedSyntax
		   ;

defaultSyntax : LEFT_PAREN fieldSettingList RIGHT_PAREN
			  ;
fieldSettingList :
	(fieldSetting
	| fieldSetting COMMA fieldSettingList)?
				 ;


fieldSetting : primitiveFieldName setting
			 ;

definedSyntax : LEFT_CURLY definedSyntaxToken empty * RIGHT_CURLY
			  ;

definedSyntaxToken :
	literal
	| setting
				   ;

setting :
	type
	| value
	| valueSet
	| object
	| objectSet
		;

definedObjectSet :
	externalObjectSetReference
	| ObjectSetReference
				 ;

externalObjectSetReference : ModuleReference DOT ObjectSetReference
						   ;

objectSetAssignment : ObjectSetReference definedObjectClass ASSIGNMENT_OPERATOR objectSet
					;

objectSet : LEFT_CURLY objectSetSpec RIGHT_CURLY
		  ;

objectSetSpec :
	rootElementSetSpec
	| rootElementSetSpec COMMA ELLIPSIS
	| ELLIPSIS
	| ELLIPSIS COMMA additionalElementSetSpec
	| rootElementSetSpec COMMA ELLIPSIS COMMA additionalElementSetSpec
			  ;

objectSetElements :
	object
	| definedObjectSet
	| objectSetFromObjects
	| parameterizedObjectSet
				  ;

objectClassFieldType : definedObjectClass DOT fieldName
					 ;

objectClassFieldValue :
	openTypeFieldVal
	| fixedTypeFieldVal
					  ;

openTypeFieldVal : type COLON value
				 ;

fixedTypeFieldVal :
	builtinValue
	| referencedValue
				  ;

xMLObjectClassFieldValue :
	xMLOpenTypeFieldVal
	| xMLFixedTypeFieldVal
						 ;

xMLOpenTypeFieldVal :
	xMLTypedValue
	| xmlhstring
					;

xMLFixedTypeFieldVal : xMLBuiltinValue
					 ;

informationFromObjects :
	valueFromObject
	| valueSetFromObjects
	| typeFromObject
	| objectFromObject
	| objectSetFromObjects
					   ;
referencedObjects :
	definedObject
	| parameterizedObject
	| definedObjectSet
	| parameterizedObjectSet
				  ;

valueFromObject : referencedObjects DOT fieldName
				;

valueSetFromObjects : referencedObjects DOT fieldName
					;

typeFromObject : referencedObjects DOT fieldName
			   ;

objectFromObject : referencedObjects DOT fieldName
				 ;

objectSetFromObjects : referencedObjects DOT fieldName
					 ;

instanceOfType : INSTANCE_LITERAL OF_LITERAL definedObjectClass
			   ;

instanceOfValue : value
				;

xMLInstanceOfValue : xMLValue
				   ;

generalConstraint :
	userDefinedConstraint
	| tableConstraint
	| contentsConstraint
				  ;
	
userDefinedConstraint : CONSTRAINED_BY_LITERAL LEFT_CURLY userDefinedConstraintParameterList RIGHT_CURLY
					  ;
								  
userDefinedConstraintParameterList:
	(   userDefinedConstraintParameter
	   | userDefinedConstraintParameter COMMA userDefinedConstraintParameterList )?
								  ;

userDefinedConstraintParameter :
	governor COLON value
	| governor COLON object
	| definedObjectSet
	| type
	| definedObjectClass
							   ;

tableConstraint :
	simpleTableConstraint
	| componentRelationConstraint
				;

simpleTableConstraint : objectSet
					  ;

componentRelationConstraint : LEFT_CURLY definedObjectSet RIGHT_CURLY LEFT_CURLY atNotationList RIGHT_CURLY
							;
atNotationList:
	atNotation
	| atNotation COMMA atNotationList
			  ;

atNotation :
	AT componentIdList
	| AT DOT level componentIdList
		   ;

level : 
	(DOT level) ?
	  ;

componentIdList : 
	Identifier
	| componentIdList DOT Identifier
				;

contentsConstraint :
	CONTAINING_LITERAL type
	| ENCODED_BY_LITERAL value
	| CONTAINING_LITERAL type ENCODED_BY_LITERAL value
				   ;

parameterizedAssignment :
	parameterizedTypeAssignment
	| parameterizedValueAssignment
	| parameterizedValueSetTypeAssignment
	| parameterizedObjectClassAssignment
	| parameterizedObjectAssignment
	| parameterizedObjectSetAssignment
						;

parameterizedTypeAssignment : TypeReference parameterList ASSIGNMENT_OPERATOR type
							;

parameterizedValueAssignment : ValueReference parameterList type ASSIGNMENT_OPERATOR value
							 ;

parameterizedValueSetTypeAssignment : TypeReference parameterList type ASSIGNMENT_OPERATOR valueSet
									;

parameterizedObjectClassAssignment : ObjectClassReference parameterList ASSIGNMENT_OPERATOR objectClass
								   ;

parameterizedObjectAssignment : ObjectReference parameterList definedObjectClass ASSIGNMENT_OPERATOR object
							  ;

parameterizedObjectSetAssignment : ObjectSetReference parameterList definedObjectClass ASSIGNMENT_OPERATOR objectSet
								 ;

parameterList : LEFT_CURLY parameterListComma RIGHT_CURLY
			  ;

parameterListComma :
	parameter
	| parameter COMMA parameterListComma
				   ;

parameter :
	paramGovernor COLON dummyReference
	| dummyReference
		  ;

paramGovernor :
	governor
	| dummyGovernor
			  ;

governor :
	type
	| definedObjectClass
		 ;

dummyGovernor : dummyReference
			  ;

dummyReference : reference
			   ;

parameterizedReference :
	reference
	| reference LEFT_CURLY RIGHT_CURLY
					   ;

simpleDefinedType :
	externalTypeReference
	| TypeReference
				  ;

simpleDefinedValue :
	externalValueReference
	| ValueReference
				   ;

parameterizedType : simpleDefinedType actualParameterList
				  ;

parameterizedValue : simpleDefinedValue actualParameterList
				   ;

parameterizedValueSetType : simpleDefinedType actualParameterList
						  ;

parameterizedObjectClass : definedObjectClass actualParameterList
						 ;

parameterizedObjectSet : definedObjectSet actualParameterList
					   ;

parameterizedObject : definedObject actualParameterList
					;

actualParameterList : LEFT_CURLY actualParameterListComma RIGHT_CURLY
					;

actualParameterListComma:
	actualParameter
	| actualParameter COMMA actualParameterListComma
						;


actualParameter :
	type
	| value
	| valueSet
	| definedObjectClass
	| object
	| objectSet
				;

ASSIGNMENT_OPERATOR
	:           '::='
	;

EQUALS
	:           '='
	;

QUOTE
	:           '\''
	;

DOUBLE_QUOTE
	:           '"'
	;

SEMI_COLON
	:           ';'
	;

EXCLAMATION
	:           '!'
	;

COLON
	:           ':'
	;

COMMA
	:           ','
	;

DOT
	:           '.'
	;

AT
	:           '@'
	;

AMPERSAND
	:           '&'
	;

STAR
	:           '*'
	;

HYPHEN
	:           '-'
	;

PLUS
	:           '+'
	;

RANGE
	:           '..'
	;

PIPE
	:           '|'
	;

SLASH
	:           '/'
	;

CARET
	:           '^'
	;

ELLIPSIS
	:           '...'
	;

BEGIN_LITERAL
	:           'BEGIN'
	;

END_LITERAL
	:           'END'
	;

LEFT_CURLY
	:           '{'
	;

RIGHT_CURLY
	:           '}'
	;

LEFT_PAREN
	:           '('
	;

RIGHT_PAREN
	:           ')'
	;

LEFT_BRACKET
	:           '['
	;

RIGHT_BRACKET
	:           ']'
	;

DOUBLE_LEFT_BRACKET
	:           '[['
	;

DOUBLE_RIGHT_BRACKET
	:           ']]'
	;

LESS_THAN
	:           '<'
	;

GREATER_THAN
	:           '>'
	;

SLASH_GREATER_THAN
	:           '/>'
	;

LESS_THAN_SLASH
	:           '</'
	;

OF_LITERAL
	:           'OF'
	;

DEFINITIONS_LITERAL
	:   	'DEFINITIONS'
	;

INSTRUCTIONS_LITERAL
	:           'INSTRUCTIONS'
	;

EXPLICIT_LITERAL 
	:           'EXPLICIT'
	;

TAGS_LITERAL
	:           'TAGS'
	;

IMPLICIT_LITERAL
	:           'IMPLICIT'
	;

AUTOMATIC_LITERAL
	:           'AUTOMATIC'
	;

EXTENSIBILITY_LITERAL
	:           'EXTENSIBILITY'
	;

IMPLIED_LITERAL
	:           'IMPLIED'
	;

EXPORTS_LITERAL
	:           'EXPORTS'
	;

ALL_LITERAL
	:           'ALL'
	;

IMPORTS_LITERAL
	:           'IMPORTS'
	;

FROM_LITERAL
	:           'FROM'
	;

BOOLEAN_LITERAL
	:           'BOOLEAN'
	;

TRUE_LITERAL
	:           'TRUE'
	;

FALSE_LITERAL
	:           'FALSE'
	;

TRUE_LOWER
	:           'true'
	;

FALSE_LOWER
	:           'false'
	;

INTEGER_LITERAL
	:           'INTEGER'
	;

ENUMERATED_LITERAL
	:           'ENUMERATED'
	;

REAL_LITERAL
	:           'REAL'
	;

PLUS_INFINITY_LITERAL
	:           'PLUS-INFINITY'
	;

MINUS_INFINITY_LITERAL
	:           'MINUS-INFINITY'
	;

NOT_A_NUMBER_LITERAL
	:           'NOT-A-NUMBER'
	;

BIT_LITERAL
	:           'BIT'
	;

STRING_LITERAL
	:           'STRING'
	;

CONTAINING_LITERAL
	:           'CONTAINING'
	;

OCTET_LITERAL
	:           'OCTET'
	;

NULL_LITERAL
	:           'NULL'
	;

SEQUENCE_LITERAL
	:           'SEQUENCE'
	;

ENCODING_CONTROL_LITERAL
	:           'ENCODING-CONTROL'
	;

INCLUDES_LITERAL
	:           'INCLUDES'
	;

UNIVERSAL_LITERAL
	:           'UNIVERSAL'
	;

APPLICATION_LITERAL
	:           'APPLICATION'
	;

PRIVATE_LITERAL
	:           'PRIVATE'
	;

OBJECT_LITERAL
	:           'OBJECT'
	;

IDENTIFIER_LITERAL
	:           'IDENTIFIER'
	;

RELATIVE_OID_LITERAL
	:           'RELATIVE-OID'
	;

OID_IRI_LITERAL
	:           'OID-IRI'
	;

SETTINGS_LITERAL
	:           'SETTINGS'
	;

PATTERN_LITERAL
	:           'PATTERN'
	;

PRESENT_LITERAL
	:           'PRESENT'
	;

ABSENT_LITERAL
	:           'ABSENT'
	;

OPTIONAL_LITERAL
	:           'OPTIONAL'
	;

MIN_LITERAL
	:           'MIN'
	;

MAX_LITERAL
	:           'MAX'
	;

WITH_LITERAL
	:           'WITH'
	;

COMPONENT_LITERAL
	:           'COMPONENT'
	;

COMPONENTS_LITERAL
	:           'COMPONENTS'
	;

SIZE_LITERAL
	:           'SIZE'
	;

UNION_LITERAL
	:           'UNION'
	;

INTERSECTION_LITERAL
	:           'INTERSECTION'
	;

INF_LITERAL
	:           'INF'
	;

NAN_LITERAL
	:           'NaN'
	;

DEFAULT_LITERAL
	:           'DEFAULT'
	;

SET_LITERAL
	:           'SET'
	;

CHOICE_LITERAL
	:           'CHOICE'
	;

EMBEDDED_LITERAL
	:           'EMBEDDED'
	;

PDV_LITERAL
	:           'PDV'
	;

EXTERNAL_LITERAL
	:           'EXTERNAL'
	;

INTERNAL_LITERAL
	:           'INTERNAL'
	;

CHARACTER_LITERAL
	:           'CHARACTER'
	;

EXCEPT_LITERAL
	:           'EXCEPT'
	;

DATE_LITERAL
	:           'DATE'
	;

TIME_LITERAL
	:           'TIME'
	;

DATE_TIME_LITERAL
	:           'DATE-TIME'
	;

TIME_OF_DAY_LITERAL
	:           'TIME-OF-DAY'
	;

DURATION_LITERAL
	:           'DURATION'
	;

RELATIVE_OID_IRI_LITERAL
	:           'RELATIVE-OID-IRI'
	;

UNIQUE_LITERAL
	:           'UNIQUE'
	;

TYPE_IDENTIFIER_LITERAL
	:           'TYPE-IDENTIFIER'
	;

ABSTRACT_SYNTAX_LITERAL
	:           'ABSTACT-SYNTAX'
	;

CLASS_LITERAL
	:           'CLASS'
	;

SYNTAX_LITERAL
	:           'SYNTAX'
	;

INSTANCE_LITERAL
	:           'INSTANCE'
	;

CONSTRAINED_BY_LITERAL
	:           'CONSTRAINED BY'
	;

ENCODED_BY_LITERAL
	:           'ENCODE BY'
	;

fragment
DIGIT	:	'0'..'9'
		;

fragment
NON_ZERO_DIGIT
	:           '1'..'9'
	;

Number :
		   NON_ZERO_DIGIT (DIGIT)*
	   | '0'
	   ;

fragment
Exponent
	: ('e'|'E') (HYPHEN | PLUS)? (DIGIT | (NON_ZERO_DIGIT (DIGIT)+))
	;

RealNumber :
			   Number
		   |   Number DOT (DIGIT)+
		   |   Number DOT (DIGIT)+ Exponent
		   ;


BString
	:           QUOTE ('0'..'1')* '\'B'
;

fragment	
HEXDIGIT : (DIGIT|'a'..'f'|'A'..'F') ;

HString  : QUOTE (NON_ZERO_DIGIT|'a'..'f'|'A'..'F') HEXDIGIT* '\'H' ;

TStringChars :
				 DIGIT
			 |   '+' | '-'
			 |   COLON
			 |   DOT
			 |   COMMA
			 |   SLASH
			 |   'C' | 'D' | 'H' | 'M' | 'R' | 'P'
			 |   'S' | 'T' | 'W' | 'Y' | 'Z'
			 ;

TString : DOUBLE_QUOTE TStringChars+ DOUBLE_QUOTE
		;

XMLTString : TString
		   ;

ExtendedTrue
	:           '1' | 'true'
	;


ExtendedFalse
	:           '0' | 'false'
	;

fragment
UPPERCASE_CHAR
	:
		'\u0041'..'\u005a'
	|   '\u00c0'..'\u00d6'
	|   '\u00d8'..'\u00de'
	;

fragment
	LOWERCASE_CHAR
	:
		'\u0061'..'\u007a'
	|   '\u00df'..'\u00ff'
	;
  
fragment
	LETTER
	:
		UPPERCASE_CHAR
	| LOWERCASE_CHAR
	;  

Identifier
	:
		LOWERCASE_CHAR (LETTER | DIGIT | HYPHEN LETTER | HYPHEN DIGIT)*
	;

ValueReference
	:
		LOWERCASE_CHAR (LETTER | DIGIT | HYPHEN LETTER | HYPHEN DIGIT)*
	;
	
TypeReference
	:
		UPPERCASE_CHAR (LETTER | DIGIT | HYPHEN LETTER | HYPHEN DIGIT)*
	;

ModuleReference
	:
		UPPERCASE_CHAR (LETTER | DIGIT | HYPHEN LETTER | HYPHEN DIGIT)*
	;

EncodingReference
	:
		UPPERCASE_CHAR (UPPERCASE_CHAR | DIGIT | HYPHEN UPPERCASE_CHAR | HYPHEN DIGIT)*
	;

IntegerUnicodeLabel
	:   Number
	;

ObjectReference
	:
		ValueReference
	;

ObjectClassReference
	:
		UPPERCASE_CHAR (UPPERCASE_CHAR | DIGIT | HYPHEN UPPERCASE_CHAR | HYPHEN DIGIT)*
	;

ObjectSetReference
	:
		TypeReference
	;

TypeFieldReference
	:
		AMPERSAND TypeReference
	;

ValueFieldReference
	:
		AMPERSAND ValueReference
	;

ValueSetFieldReference
	:
		AMPERSAND TypeReference
	;

ObjectFieldReference
	:
		AMPERSAND ObjectReference
	;

ObjectSetFieldReference
	:
		AMPERSAND ObjectSetReference
	;

Word
	:
		UPPERCASE_CHAR (UPPERCASE_CHAR | HYPHEN UPPERCASE_CHAR )*
	;

Whitespace
  : [ \t\n\r]+ {if(ignore) skip();}
  ;