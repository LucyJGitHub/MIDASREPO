/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Restore data from tape')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - History and Audit Facility Module                   */
/*                                                                   */
/*       HFC0350  - RESTORE DATA FROM TAPE                           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Prev Amend No. 207764             Date 23Jul02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      143606             Date 26Apr99              */
/*                      S01408             DATE 04MAY95              */
/*                      049980             DATE 03FEB93              */
/*                      S01379             DATE 17SEP92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       207764 - Change all SAV* and RST* commands to print a       */
/*                report of objects saved or restored.               */
/*       143606 - Restore of HAF data from TAP01 fails.              */
/*       S01408 - Addition of core hook HFC0350MP1                   */
/*       049980 - Access AOHAFDR0 to determine the value of field    */
/*                ETSAVE (Save HAF data to media.)                   */
/*                                                                   */
/*       S01379 - New program for HAF.                               */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(HFFILEL1)
 
             DCL        VAR(&XY) TYPE(*CHAR) LEN(1000) VALUE('(')
             DCL        VAR(&X) TYPE(*DEC) LEN(15 5)
             DCL        VAR(&Y) TYPE(*DEC) LEN(15 5)
             DCL        VAR(&XX) TYPE(*CHAR) LEN(4)
             DCL        VAR(&YY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TT) TYPE(*DEC) LEN(1 0) VALUE(0)
             DCL        VAR(&ITEX) TYPE(*CHAR) LEN(10)
             DCL        VAR(&VOL) TYPE(*CHAR) LEN(10) VALUE(HFSAVE)
             DCL        VAR(&HFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&UNIT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RESTSAVE) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)  +
                           VALUE('*DBERR ')                           /*049980*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)  +
                           VALUE('*FIRST ')                           /*049980*/
             DCL        VAR(&SAVE) TYPE(*CHAR) LEN(1)                 /*049980*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)              /*049980*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(80)             /*049980*/
 
/*/COPY WNCPYSRC,HFC0350001                                          */
/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,HFC0350003                                          */
/* */                                                                 /*049980*/
/* Get ICD information on 'Save HAF data to media' */                 /*049980*/
/* */                                                                 /*049980*/
             CALL       AOHAFDR0 PARM(&RTCD &OPTN &DSFDY)             /*049980*/
             CHGVAR     VAR(&SAVE) VALUE(%SST(&DSFDY 20 1))           /*049980*/
             IF         COND(&SAVE *NE 'Y') THEN(DO)                  /*049980*/
                RTVMSG     MSGID(HFM0014) MSGF(MIDASMSG) +
                           MSG(&MESSAGE)                              /*049980*/
                CHGDTAARA  DTAARA(MIDASMSG (301 50)) +
                           VALUE(%SST(&MESSAGE 1 47))                 /*049980*/
                CHGDTAARA  DTAARA(MIDASMSG (351 50)) +
                           VALUE(%SST(&MESSAGE 49 32))                /*049980*/
                CALL       PGM(HFC0010) PARM('HFC0350' 'ENTER' +
                           &REPLY)                                    /*049980*/
                GOTO       CMDLBL(END)                                /*049980*/
             ENDDO                                                    /*049980*/
             ELSE       CMD(CHGVAR VAR(&UNIT) +
                           VALUE(%SST(&DSFDY 21 10)))                 /*049980*/
/* */
/* Get library ID and build the HFLIB variable */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LID)
             CHGVAR     VAR(&HFLIB) VALUE(&LID *CAT 'HFLIB')
             CHGVAR     VAR(&DILIB) VALUE(&LID *CAT 'DILIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,HFC0350MP1                                          */
                                                                      /*S01408*/
 
             CHGJOB     SWS(00000000)
 
/* */
/* Save the dataarea HFREST */
/* */
             RTVDTAARA  DTAARA(HFREST) RTNVAR(&RESTSAVE)
 
/* */
/* Call HF0350 to update sequence */
/* */
             CALL       PGM(HF0350)
             IF         COND(%SWITCH(1XXXXXXX)) THEN(GOTO +
                          CMDLBL(END))
 
/* */
/* Retrieve stored information from HFREST dataarea */
/* */
             RTVDTAARA  DTAARA(HFREST (1 4)) RTNVAR(&XX)
             RTVDTAARA  DTAARA(HFREST (5 4)) RTNVAR(&YY)
             CHGVAR     VAR(&X) VALUE(&XX)
             CHGVAR     VAR(&Y) VALUE(&YY)
             RTVDTAARA  DTAARA(HFREST (9 10)) RTNVAR(&ITEX)
 
 
/* */
/* Build CPYF variable */
/* */
             CHGVAR     VAR(&XY) VALUE('CPYF FROMFILE(QTEMP/XX) +
                          TOFILE(' *TCAT &HFLIB *TCAT '/' *TCAT +
                          &ITEX *TCAT ') TOMBR(JRNHIST) +
                          FMTOPT(*NOCHK) MBROPT(*ADD) INCREL' *TCAT +
                          &XY)
 
/* */
/* Clear member JRNFIL in &ITEX */
/* */
             CLRPFM     FILE(&HFLIB/&ITEX) MBR(JRNHIST)
 
/* */
/* If member not found then add it */
/* */
             MONMSG     MSGID(CPF0000) EXEC(ADDPFM FILE(HFLIB/&ITEX) +
                          MBR(JRNHIST))
 
/* */
/* Read all records from file */
/* */
LOOP1:
             RCVF
 
             MONMSG     MSGID(CPF0000) EXEC(DO)
/* */
/* End of file so complete the command variable and exit this loop */
/* */
             CHGVAR     VAR(&XY) VALUE(&XY *TCAT ')')
             GOTO       CMDLBL(LOOP)
             ENDDO
 
/* */
/* Select the relevant file */
/* */
             IF         COND(&FFILE *NE &ITEX) THEN(GOTO CMDLBL(LOOP1))
             IF         COND(&TT *EQ 0) THEN(DO)
             CHGVAR     VAR(&XY) VALUE(&XY *TCAT '(*IF ')
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&XY) VALUE(&XY *BCAT '(*OR ')
             ENDDO
 
/* */
/* Use information just read to build command variable */
/* */
             CHGVAR     VAR(&XY) VALUE(&XY *TCAT ' JOOBJ *EQ ' *BCAT +
                          &FFORM *TCAT ')')
             CHGVAR     VAR(&TT) VALUE(1)
 
/* */
/* Read next record */
/* */
             GOTO       CMDLBL(LOOP1)
 
LOOP:
 
/* */
/* Delete the XX file in QTEMP if it exists */
/* */
             DLTF       FILE(QTEMP/XX)
             MONMSG     MSGID(CPF0000)
 
/* */
/* Abandon restore */
/* */
             IF         COND(&X *GT &Y) THEN(DO)
/*********** CHKTAP     DEV(TAP01) ENDOPT(*REWIND)     ***/           /*143606*/
             CHKTAP     DEV(&UNIT) ENDOPT(*REWIND)                    /*143606*/
             GOTO       CMDLBL(END)
             ENDDO
 
/* */
/* Decide where to restore the data from */
/* */
/*RETRY:     RTVDTAARA  DTAARA(JNSTAT (39 10)) RTNVAR(&UNIT) */       /*049980*/
 RETRY:                                                               /*049980*/
 
/* */
/* Check the correct volume is mounted */
/* */
             CHKTAP     DEV(&UNIT) VOL(&VOL)
 
/* */
/* Wrong volume so send message */
/* */
             MONMSG     MSGID(CPF0000) EXEC(DO)
 
/* */
/* Send messages to inform user of problem, to rectify it or cancel */
/* */
             SNDPGMMSG  MSG(' ') TOPGMQ(*EXT) MSGTYPE(*DIAG) /* +
                          Blank Line */
             SNDPGMMSG  MSG('HAF has detected the incorrect +
                          volume on tape drive' *BCAT &UNIT) +
                          TOPGMQ(*EXT) MSGTYPE(*DIAG) /* Info first */
             SNDPGMMSG  MSG('Please mount volume' *BCAT &VOL *BCAT +
                          'on tape drive' *BCAT &UNIT) TOPGMQ(*EXT) +
                          MSGTYPE(*DIAG) /* More info */
             SNDUSRMSG  MSG('C to cancel save, any other key to +
                          retry.') TOMSGQ(*EXT) MSGRPY(&REPLY) /* +
                          Action to take */
 
/* */
/* Check the reply. If C then cancel otherwise go back to look at */
/* JNSTAT in case the save destination has been changed. */
/* */
             IF         COND((&REPLY *EQ 'C') *OR (&REPLY *EQ 'c')) +
                          THEN(DO)
             SNDPGMMSG  MSG('Save cancelled at the request of the +
                          user') TOPGMQ(*EXT) /* Abandoned */
 
/* */
/* Reset the data area HFREST as before HF0350 */
/* */
             CHGDTAARA  DTAARA(HFREST) VALUE(&RESTSAVE)
             GOTO       CMDLBL(END)
             ENDDO
             GOTO       CMDLBL(RETRY)
             ENDDO
 
/* */
/* Restore the data */
/* */
/**********  RSTOBJ     OBJ(XX) SAVLIB(&HFLIB) DEV(&UNIT) +     */                        /*207764*/
/**********               OBJTYPE(*FILE) VOL(&VOL) SEQNBR(&X) + */                        /*207764*/
/**********               ENDOPT(*LEAVE) RSTLIB(QTEMP)          */                        /*207764*/
             RSTOBJ     OBJ(XX) SAVLIB(&HFLIB) DEV(&UNIT) +
                          OBJTYPE(*FILE) VOL(&VOL) SEQNBR(&X) +
                          ENDOPT(*LEAVE) RSTLIB(QTEMP) +
                          OUTPUT(*PRINT)                                                  /*207764*/
 
/* */
/* Execute the command variable using QCMDEXC */
/* */
             CALL       PGM(QCMDEXC) PARM(&XY 1000)
             CHGVAR     VAR(&X) VALUE(&X + 1)
 
/* */
/* Read next record */
/* */
             GOTO LOOP
 
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0350 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             CALL       PGM(AOHAFDR0) PARM(&RTCD '*FREE' &DSFDY)      /*049980*/
/*/COPY WNCPYSRC,HFC0350002                                          */
             ENDPGM
