/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ED Bulk copy completion component')             */
/********************************************************************/
/*                                                                  */
/*       Midas - Midas Export Data Interface Module                 */
/*                                                                  */
/*       EDC0030 - Bulk Transfer Completion Component               */
/*                                                                  */
/*       Function : This program combines the PF/EDSAVxPD files     */
/*                  into PF/EDSAVEPD and calls the Bulk Transfer    */
/*                  audit report program.                           */
/*                                                                  */
/*       Called by: COB process                                     */
/*                                                                  */
/*       Calls :        ED0030                                      */
/*                      AOMEXPR0                                    */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. CCB009             Date 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CED002             Date 23May97              */
/*                      CED001             DATE 27AUG96             */
/*                      S01493 *CREATE     DATE 16MAY94             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB009 - Journal files throughout close of business        */
/*       CED002 - ED Enhancements                                   */
/*       CED001 - Export Data Phases III & IV                       */
/*       S01493 - Midas Export Data Interface Module                */
/*                                                                  */
/********************************************************************/
             PGM
 
/* Copyright statement definition */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Other declarations */
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(80)
             DCL        VAR(&BUEN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST')
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(7)
             DCL        VAR(&AOMEXP) TYPE(*CHAR) LEN(200)
             DCL        VAR(&MSGID)   TYPE(*CHAR) LEN(7)              /*CED001*/
             DCL        VAR(&MSGDTA)  TYPE(*CHAR) LEN(100)            /*CED001*/
             DCL        VAR(&MSGF)    TYPE(*CHAR) LEN(10)             /*CED001*/
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)             /*CED001*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/*/COPY WNCPYSRC,EDC0030001                                          */
 
/* Global error monitor */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
             CHGJOB     SWS(00000000)
 
/* Copyright statement definition at runtime */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             CHGVAR     VAR(&MEM) VALUE('EDC0030 - ED Bulk Transfer +
                          Completion Component')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/***********************                                              /*CED002*/
/**Purge*PF/EDSAVEPD*of*old Bulk Transfer batch details */            /*CED002*/
/***********************                                              /*CED002*/
/************CALL*******PGM(ED0030)                                   /*CED002*/
/************IF*********COND(%SWITCH(XXXXXX11)) THEN(GOTO +           /*CED002*/
/***********************  CMDLBL(ABNOR))                              /*CED002*/
 
/* Carry out completion processing if I/F is active */
 
             CHGVAR     VAR(&RTNC) VALUE('*MSG   ')                   /*CED001*/
             CALL       PGM(AOMEXPR0) PARM(&RTNC &OPTN &AOMEXP)
 
             IF         COND(&RTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&BUEN) VALUE(%SUBSTRING(&AOMEXP 26 1))
 
             IF         COND(&BUEN *EQ 'N') THEN(GOTO CMDLBL(ENDCLPGM))
 
/* Merge list of members */
                                                                      /*CED001*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(*ALL) JRN(JEDC0010)                      /*CED001*/
             MONMSG     MSGID(CPF7032 CPF9801)                        /*CED001*/
                                                                      /*CED001*/
             DLTJRN     JRN(JEDC0010)                                 /*CED001*/
             MONMSG     MSGID(CPF2105)                                /*CED001*/
                                                                      /*CED001*/
             CHGJOB     INQMSGRPY(*DFT)                               /*CED001*/
             DLTJRNRCV  JRNRCV(JREDC0010)                             /*CED001*/
             MONMSG     MSGID(CPF2105)                                /*CED001*/
             CHGJOB     INQMSGRPY(*RQD)                               /*CED001*/
             ENDDO                                                    /*CCB009*/
/*************************                                     /*CED001 CED002*/
/************CPYF*******FROMFILE(EDSAVXPD) TOFILE(EDSAVEPD) +         /*CED002*/
/*************************FROMMBR(*FIRST) TOMBR(*FIRST) +             /*CED002*/
/*************************MBROPT(*ADD) FMTOPT(*MAP *DROP)      /*CED001 CED002*/
                                                                      /*CED002*/
/* Flag outstanding files available for transfer */                   /*CED002*/
             CALL       PGM(ED0029)                                   /*CED002*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                              /*CED002*/
                                                                      /*CED002*/
 
/************CPYF       FROMFILE(EDSAV0PD) TOFILE(EDSAVEPD) +         /*CED001*/
/************             FROMMBR(*FIRST) TOMBR(*FIRST) MBROPT(*ADD)  /*CED001*/
/************                                                         /*CED001*/
/************CPYF       FROMFILE(EDSAV1PD) TOFILE(EDSAVEPD) +         /*CED001*/
/************             FROMMBR(*FIRST) TOMBR(*FIRST) MBROPT(*ADD)  /*CED001*/
/************                                                         /*CED001*/
/************CPYF       FROMFILE(EDSAV2PD) TOFILE(EDSAVEPD) +         /*CED001*/
/************             FROMMBR(*FIRST) TOMBR(*FIRST) MBROPT(*ADD)  /*CED001*/
/************                                                         /*CED001*/
/************CPYF       FROMFILE(EDSAV3PD) TOFILE(EDSAVEPD) +         /*CED001*/
/************             FROMMBR(*FIRST) TOMBR(*FIRST) MBROPT(*ADD)  /*CED001*/
/************                                                         /*CED001*/
/************CPYF       FROMFILE(EDSAV4PD) TOFILE(EDSAVEPD) +         /*CED001*/
/************             FROMMBR(*FIRST) TOMBR(*FIRST) MBROPT(*ADD)  /*CED001*/
/************                                                         /*CED001*/
/************CPYF       FROMFILE(EDSAV5PD) TOFILE(EDSAVEPD) +         /*CED001*/
/************             FROMMBR(*FIRST) TOMBR(*FIRST) MBROPT(*ADD)  /*CED001*/
/************                                                         /*CED001*/
/************CPYF       FROMFILE(EDSAV6PD) TOFILE(EDSAVEPD) +         /*CED001*/
/************             FROMMBR(*FIRST) TOMBR(*FIRST) MBROPT(*ADD)  /*CED001*/
/************                                                         /*CED001*/
/************CPYF       FROMFILE(EDSAV7PD) TOFILE(EDSAVEPD) +         /*CED001*/
/************             FROMMBR(*FIRST) TOMBR(*FIRST) MBROPT(*ADD)  /*CED001*/
/************                                                         /*CED001*/
/************CPYF       FROMFILE(EDSAV8PD) TOFILE(EDSAVEPD) +         /*CED001*/
/************             FROMMBR(*FIRST) TOMBR(*FIRST) MBROPT(*ADD)  /*CED001*/
/************                                                         /*CED001*/
/************CPYF       FROMFILE(EDSAV9PD) TOFILE(EDSAVEPD) +         /*CED001*/
/************             FROMMBR(*FIRST) TOMBR(*FIRST) MBROPT(*ADD)  /*CED001*/
 
/* Audit report */
 
             CALL       PGM(ED0035)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
                                                                      /*CED002*/
/*/COPY WNCPYSRC,EDC0030002                                          */
             GOTO       CMDLBL(ENDCLPGM)
 
/* Abnormal termination */
 
ABNOR:
/************SNDPGMMSG  MSG('EDC0030 ED Bulk Transfer Completion +    /*CED001*/
/************             Component TERMINATED ABNORMALLY') +         /*CED001*/
/************             TOMSGQ(*SYSOPR) MSGTYPE(*INQ)               /*CED001*/
/************MONMSG     MSGID(CPF0000 MCH0000)                        /*CED001*/
/************                                                         /*CED001*/
                                                                      /*CED001*/
             RCVMSG     MSGTYPE(*EXCP) RMV(*NO) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID) MSGF(&MSGF) +
                          MSGFLIB(&MSGFLIB)                           /*CED001*/
             MONMSG     MSGID(CPF0000)                                /*CED001*/
                                                                      /*CED001*/
             IF         COND(&MSGID *NE '       ') THEN(DO)           /*CED001*/
                 SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                            MSGDTA(&MSGDTA) TOMSGQ(MOPERQ MRUNQ)      /*CED001*/
                 MONMSG     MSGID(CPF0000)                            /*CED001*/
             ENDDO                                                    /*CED001*/
                                                                      /*CED001*/
             SNDPGMMSG  MSG('EDC0030 ED Bulk Transfer Completion +
                          Component TERMINATED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CED001*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*CED001*/
                                                                      /*CED001*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CHGJOB     SWS(XXXXXX11)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
ENDCLPGM:
             ENDPGM
