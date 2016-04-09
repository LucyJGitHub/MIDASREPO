/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MT Install N$UPL in ORION Library')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Midas Telex Module                                  */
/*                                                                   */
/*       MTC3000 - Install LF/N$UPL in ORION Database Library        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CUT008             Date 08Feb11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 28May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CMT001  *CREATE    Date 06Feb99              */
/*                      nnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUT008  - CRTOBJ rewrite.                                   */
/*                 Change of CRTOBJ parameters.                      */
/*       BG18886 - Amend non-standard codes.                         */
/*       CMT001 - Telex Module upgrade to Midas Mailer (ORION        */
/*                Telex 3.3). Compile Midas LF/N$UPL to Orion        */
/*                Database Library.                                  */
/*                                                                   */
/*********************************************************************/
 
             PGM    PARM(&RTCDE &PMODE)
 
/** Declare variables */
 
             DCL    VAR(&PMODE)  TYPE(*CHAR) LEN(1)
             DCL    VAR(&RTCDE)  TYPE(*CHAR) LEN(7)
             DCL    VAR(&SRCLIB) TYPE(*CHAR) LEN(10)
             DCL    VAR(&ORILIB) TYPE(*CHAR) LEN(10)
             DCL    VAR(&LOCCOD) TYPE(*CHAR) LEN(5)
             DCL    VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/** Declare ORION configuration file */
 
             DCLF   FILE(*LIBL/N#CF) RCDFMT(N#CF01)
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000)
 
/** Global Monitor Message */
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
 
/* Mode 1 - First call */
 
             IF         COND(&PMODE *EQ '1') THEN(DO)
 
/** Set up MIDAS database library */
 
        RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
/*******CHGVAR  &SRCLIB  VALUE(%SUBSTRING(&SDSTAT 6 2)**'DTALIB')                     */ /*BG18886*/
             CHGVAR     VAR(&SRCLIB) VALUE(%SUBSTRING(&SDSTAT 6 2) +
                          *CAT 'DTALIB')                                                 /*BG18886*/
 
/** Set up ORION database library */
 
        RCVF   RCDFMT(N#CF01)
 
        MONMSG     MSGID(CPF4101) EXEC(DO)
           SNDPGMMSG  MSG('Orion Configuration File N#CF +
             not found. Compilation terminated.') TOMSGQ(MOPERQ)
           MONMSG  MSGID(CPF0000 RPG0000 MCH0000)
 
           GOTO  CMDLBL(ABNOR)
        ENDDO
 
        CHGVAR     VAR(&LOCCOD) VALUE(&CFLOCC)
/*******CHGVAR     VAR(&ORILIB) VALUE('#F'**&LOCCOD**'400')                           */ /*BG18886*/
             CHGVAR     VAR(&ORILIB) VALUE('#F' *CAT &LOCCOD *CAT +
                          '400')                                                         /*BG18886*/
 
/** Include Orion libs in current library list */
 
         ADDLIBLE  LIB(#NC400) POSITION(*FIRST)
         MONMSG    MSGID(CPF0000)
 
         ADDLIBLE  LIB(&ORILIB) POSITION(*FIRST)
         MONMSG    MSGID(CPF0000)
 
/** Ensure that PF/N#UP exists before compilation, otherwise */
/** terminate the program                                    */
 
             CHKOBJ     OBJ(N#UP) OBJTYPE(*FILE)
 
             MONMSG     MSGID(CPF9801) EXEC(DO)
                SNDPGMMSG  MSG('N#UP not found in *LIBL. +
                  compilation terminated.') TOMSGQ(MOPERQ)
                MONMSG  MSGID(CPF0000 RPG0000 MCH0000)
 
                GOTO CMDLBL(ABNOR)
             ENDDO
 
/** Compile N$UPL to Orion's #Fxxxxx400 library */
 
/**********  CRTOBJ     SRCMBR(N$UPL) SRCFILE(&SRCLIB/MTDDSSRC) +                      */ /*CUT008*/
/**********               PLIB(&ORILIB)                                                */ /*CUT008*/
             CRTOBJ     OBJ(&ORILIB/N$UPL) SRCFILE(&SRCLIB/MTDDSSRC) +
                          SRCMBR(*OBJ)                                                    /*CUT008*/
             GOTO END
 
             ENDDO
 
/**/
/* Mode 2 - Second call */
/**/
             IF         COND(&PMODE *EQ '2') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
/**/
/* Mode 3 - Deletion */
/**/
             IF         COND(&PMODE *EQ '3') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Abnormal Processing */
 
 ABNOR:      SNDPGMMSG  MSG('Program MTC3000 ended abnormally') +
                          TOMSGQ(MOPERQ)
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
