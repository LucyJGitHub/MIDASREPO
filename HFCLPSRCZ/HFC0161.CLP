/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Check user layout/authority')                */
/*********************************************************************/
/*                                                                   */
/*       Midas     - History and Audit Facility Module           */
/*                                                                   */
/*       HFC0161  - CHECK AND UPDATE DATASPY/BAT USER LAYOUTS        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01379             DATE 15SEP92              */
/*       PREV AMEND NO.                    DATE                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01379 - New program for HAF.                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&OK &MBR1 &MBR2 &ITEMI)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&OK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBR1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBR2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ITEMI) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ITEM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LID) TYPE(*CHAR) LEN(2)
 
/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* */
/* Get library ID and build the HFLIB variable */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LID)
             CHGVAR     VAR(&HFLIB) VALUE(&LID *CAT 'HFLIB')
 
/* */
/* Change the item name to the 'F' file */
/* */
             CHGVAR     VAR(&ITEM) VALUE('F' *TCAT %SST(&ITEMI 2 9))
 
/* */
/* Check that the 'F' file exists and that member 1 exists; */
/* */
             CHKOBJ     OBJ(&HFLIB/&ITEM) OBJTYPE(*FILE) MBR(&MBR1) +
                          AUT(*ALL)
             MONMSG     MSGID(CPF0000) EXEC(DO)
 
/* */
/* Set return variable */
/* */
               CHGVAR     VAR(&OK) VALUE('1')
             ENDDO
 
/* */
/* Check that the 'F' file exists and that member 2 exists; */
/* */
             CHKOBJ     OBJ(&HFLIB/&ITEM) OBJTYPE(*FILE) MBR(&MBR2) +
                          AUT(*ALL)
             MONMSG     MSGID(CPF0000) EXEC(DO)
 
/* */
/* Set return variable */
/* */
               IF         COND(&OK *EQ '1') THEN(CHGVAR VAR(&OK) +
                            VALUE('3'))
 
               IF         COND(&OK *EQ 'C') THEN(CHGVAR VAR(&OK) +
                            VALUE('2'))
             ENDDO
 
/* */
/* If either of the two members is found then bypass */
/* */
             IF         COND((&OK *EQ '1') *OR (&OK *EQ '2') *OR +
                          (&OK *EQ '3')) THEN(GOTO CMDLBL(END))
 
/* */
/* If received parm is C and neither of the members was found */
/* bypass */
/* */
             IF         COND(&OK *EQ 'C') THEN(GOTO CMDLBL(END))
 
/* */
/* If member 1 is *NONE remove the DATASPY member if it exists */
/* as user no longer wants to use this report layout */
/* */
             IF         COND(&MBR1 *EQ '*NONE') THEN(DO)
             RMVM       FILE(&HFLIB/&ITEM) MBR(DATASPY)
             MONMSG     MSGID(CPF0000)
             ENDDO
 
/* */
/* If member 1 is not *NONE and is not DATASPY then copy the       */
/* member 1 over the existing DATASPY member as the user wishes  */
/* to use the new layout for the DATASPY user */
/* */
             IF         COND((&MBR1 *NE '*NONE') *AND (&MBR1 *NE +
                          'DATASPY')) THEN(DO)
             CPYF       FROMFILE(&HFLIB/&ITEM) TOFILE(&HFLIB/&ITEM) +
                          FROMMBR(&MBR1) TOMBR(DATASPY) +
                          MBROPT(*REPLACE)
             ENDDO
 
/* */
/* If member 1 is *NONE remove the DATASPYBAT member if it exists */
/* as user no longer wants to use this report layout */
/* */
             IF         COND((&MBR2 *EQ '*NONE') *AND (&MBR2 *NE +
                          'DATASPYBAT')) THEN(DO)
             RMVM       FILE(&HFLIB/&ITEM) MBR(DATASPYBAT)
             MONMSG     MSGID(CPF0000)
             ENDDO
 
/* */
/* If member 2 is not *NONE and is not DATASPYBAT then copy the      */
/* member 1 over the existing DATASPYBAT member as the user wishes  */
/* to use the new layout for the DATASPYBAT user */
/* */
             IF         COND((&MBR2 *NE '*NONE') *AND (&MBR2 *NE +
                          'DATASPYBAT')) THEN(DO)
             CPYF       FROMFILE(&HFLIB/&ITEM) TOFILE(&HFLIB/&ITEM) +
                          FROMMBR(&MBR2) TOMBR(DATASPYBAT) +
                          MBROPT(*REPLACE)
             ENDDO
 
/* */
/* Update the dataarea HFAUDT with the member names */
/* */
             CHGDTAARA  DTAARA(HFAUDT (1 10)) VALUE(&MBR1)
             CHGDTAARA  DTAARA(HFAUDT (11 10)) VALUE(&MBR2)
 
             CHGVAR     VAR(&OK) VALUE('Y')
 
             GOTO       CMDLBL(END)
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0161 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
