/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Check scan parms and authority')             */
/*OVR  : CRTSRCPF QTEMP/QDDSSRC                                     :*/
/*OVR  : OVRDBF JRNTEMPX QTEMP/QDDSSRC                              :*/
/*********************************************************************/
/*                                                                   */
/*       Midas     - History and Audit Facility Module           */
/*                                                                   */
/*       HFC0551  - CHECK SCAN PARMS AND AUTHORITY                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 083166             DATE 17FEB95              */
/*       PREV AMEND NO. 046094             DATE 28OCT92              */
/*                      S01379             DATE 18SEP92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       083166 - Unable to insert new scan condition as the error   */
/*                message, 'these scan conditions belong to a        */
/*                different user', is always displayed.              */
/*       046094 - When copying PF/JRNDUMMY, CRTFILE(*YES) should     */
/*                be specified.                                      */
/*              - Allow *CURRENT to be specified.                    */
/*       S01379 - New program for HAF.                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*   Compiler directive for file JRNTEMPX                            */
/*********************************************************************/
 
             PGM        PARM(&ITEM &OK &STRING)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(QTEMP/JRNTEMPX)
 
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ITEM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ITEMD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&STRING) TYPE(*CHAR) LEN(80)
             DCL        VAR(&HFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(50)                /*083166*/
 
/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
                                                                      /*046094*/
/* */
/* Get library ID and build the HFLIB variable */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LID)
             CHGVAR     VAR(&HFLIB) VALUE(&LID *CAT 'HFLIB')
 
/* */
/* Build command string */
/* */
             CHGVAR     VAR(&STRING) VALUE('OVRDBF FILE(HFSCANL1) +
                          TOFILE(')
 
/* */
/* Initialise variables */
/* */
             RTVJOBA    USER(&USER)
             RTVDTAARA  DTAARA(JRN (23 10)) RTNVAR(&ITEMD)
 
 
/* */
/* Create a work source file */
/* */
             DLTF       FILE(QTEMP/JRNDUMMY)
             MONMSG     MSGID(CPF0000)
             CRTSRCPF   FILE(QTEMP/JRNDUMMY) MBR(*NONE) TEXT('Dummy +
                          source file. Do not move into another lib')
             MONMSG     MSGID(CPF0000)
             ADDPFM     FILE(QTEMP/JRNDUMMY) MBR(HFSCANL1)
             MONMSG     MSGID(CPF0000)
 
/* */
/* Override output from HF0555 to the correct src mbr */
/* */
             OVRDBF     FILE(OUTSRC) TOFILE(QTEMP/JRNDUMMY) +
                          MBR(HFSCANL1)
 
/* */
/* Call HF0555 to write the src */
/* */
             CALL       PGM(HF0555)
 
/* */
/* Delete the override */
/* */
             DLTOVR     FILE(OUTSRC)
 
/* */
/* Delete the extract file JRNTEMPX */
/* */
             DLTF       FILE(QTEMP/JRNTEMPX)
             MONMSG     MSGID(CPF0000)
 
 
/* */
/* Create JRNTEMPX */
/* */
             CRTDUPOBJ  OBJ(JRNDUMMY) FROMLIB(QTEMP) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(JRNTEMPX) DATA(*YES)
             MONMSG     MSGID(CPF0000)
 
/**********                                                       */  /*046094*/
/***/                                                                 /*046094*/
/**If*received parm is *CURRENT */                                    /*046094*/
/***/                                                                 /*046094*/
/**********  IF         COND(&ITEM *NE '*CURRENT  ') THEN(GOTO +  */  /*046094*/
/**********               CMDLBL(NOTCUR))                         */  /*046094*/
/**********                                                       */  /*046094*/
/***/                                                                 /*046094*/
/**Read*the file */                                                   /*046094*/
/***/                                                                 /*046094*/
/**********  RCVF                                                 */  /*046094*/
/**********                                                       */  /*046094*/
/**********  IF     COND(%SST(&SRCDTA 28 10) *NE &ITEMD) THEN(DO) */  /*046094*/
/**********                                                       */  /*046094*/
/***/                                                                 /*046094*/
/**Build*command string */                                            /*046094*/
/***/                                                                 /*046094*/
/**********  CHGVAR     VAR(&STRING) VALUE(&STRING *TCAT +        */  /*046094*/
/**********               'QTEMP/JRNDUMMY) MBR(HFSCANL1)')        */  /*046094*/
/**********                                                       */  /*046094*/
/***/                                                                 /*046094*/
/**Set*return code */                                                 /*046094*/
/***/                                                                 /*046094*/
/**********  CHGVAR     VAR(&OK) VALUE('9')                       */  /*046094*/
/**********  GOTO       CMDLBL(END)                               */  /*046094*/
/**********  ENDDO                                                */  /*046094*/
/**********                                                       */  /*046094*/
/***/                                                                 /*046094*/
/**Build*command string */                                            /*046094*/
/***/                                                                 /*046094*/
/**********  CHGVAR     VAR(&STRING) VALUE(&STRING *TCAT +        */  /*046094*/
/**********               'QTEMP/JRNDUMMY) MBR(HFSCANL1)')        */  /*046094*/
/**********  GOTO       CMDLBL(END)                               */  /*046094*/
/**********                                                       */  /*046094*/
/***/                                                                 /*046094*/
/**If*received parm is not *CURRENT */                                /*046094*/
/***/                                                                 /*046094*/
/*NOTCUR:****                                                      * //*046094*/
/* If &ITEM is *CURRENT then substitute the User ID */                /*046094*/
                                                                      /*046094*/
             IF         COND(&ITEM *EQ '*CURRENT') THEN(CHGVAR +
                          VAR(&ITEM) VALUE(&USER))                    /*046094*/
                                                                      /*046094*/
             CHKOBJ     OBJ(&HFLIB/JRNDDS) OBJTYPE(*FILE) MBR(&ITEM)
 
/* */
/* If member does not exist */
/* */
             MONMSG     MSGID(CPF0000) EXEC(DO)
 
/* */
/* Copy file */
/* */
/*********** CPYF       FROMFILE(QTEMP/JRNDUMMY) +
/***********              TOFILE(&HFLIB/JRNDDS) FROMMBR(HFSCANL1) +
/***********              TOMBR(&ITEM) MBROPT(*REPLACE) **/           /*046094*/
                                                                      /*046094*/
             CPYF       FROMFILE(QTEMP/JRNDUMMY) +
                          TOFILE(&HFLIB/JRNDDS) FROMMBR(HFSCANL1) +
                          TOMBR(&ITEM) MBROPT(*REPLACE) CRTFILE(*YES) /*046094*/
 
/* */
/* Monitor for error */
/* */
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&OK) VALUE('3')
 
             GOTO       CMDLBL(END)
             ENDDO
 
/* */
/* Change member created to have text of user */
/* */
             CHGPFM     FILE(&HFLIB/JRNDDS) MBR(&ITEM) TEXT(&USER)
             CHGVAR     VAR(&OK) VALUE('9')
 
/* */
/* Build command string */
/* */
             CHGVAR     VAR(&STRING) VALUE(&STRING *TCAT &HFLIB +
                          *TCAT '/JRNDDS) MBR(' *TCAT &ITEM *TCAT ')')
 
/* */
/* Lock the file member */
/* */
             ALCOBJ     OBJ((&HFLIB/JRNDDS *FILE *EXCL &ITEM)) WAIT(0)
             GOTO       CMDLBL(END)
             ENDDO
 
/* */
/* Override the file to the correct file and member */
/* */
             OVRDBF     FILE(JRNTEMPX) TOFILE(&HFLIB/JRNDDS) MBR(&ITEM)
 
/* */
/* Read the file again */
/* */
             RCVF
/* */
/* Error */
/* */
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&OK) VALUE('2')
                GOTO END
             ENDDO
/* */                                                                 /*083166*/
/* Retrieve the user that created the scan condition name */          /*083166*/
/* */                                                                 /*083166*/
             RTVMBRD    FILE(&HFLIB/JRNDDS) MBR(&ITEM) TEXT(&TEXT)    /*083166*/
 
/*********** IF         COND(%SST(&SRCDTA 8 10) *NE &USER) THEN(DO)*/ /*083166*/
             IF         COND(%SST(&TEXT 1 10) *NE &USER) THEN(DO)     /*083166*/
             CHGVAR     VAR(&OK) VALUE('2')
             GOTO       CMDLBL(END)
             ENDDO
 
             IF         COND((%SST(&SRCDTA 28 10) *NE &ITEMD) *AND +
                          (%SST(&SRCDTA 28 10) *NE '*CURRENT  ')) +
                          THEN(DO)
             CHGVAR     VAR(&OK) VALUE('1')
             GOTO       CMDLBL(END)
             ENDDO
 
 
/* */
/* FINISH COMMAND STRING */
/* */
             CHGVAR     VAR(&STRING) VALUE(&STRING *TCAT &HFLIB +
                          *TCAT '/JRNDDS) MBR(' *TCAT &ITEM *TCAT ')')
 
/* */
/* Allocate file to this job */
/* */
             ALCOBJ     OBJ((&HFLIB/JRNDDS *FILE *EXCL &ITEM)) WAIT(0)
 
             GOTO       CMDLBL(END)
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0551 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
