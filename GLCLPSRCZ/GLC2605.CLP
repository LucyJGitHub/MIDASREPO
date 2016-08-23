/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Batch trans. file split - end task split')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC2605 - Batch Transaction File Split - End Task Split     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. AR1091153          Date 25Feb12              */
/*       Prev Amend No. CGL127AM           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CEU028             Date 24Aug98              */
/*                      CCB003  *Create    Date 11Oct96              */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       AR1091153 - GLC2605 error when first member of GLBATHPA     */
/*                   has no records                                  */
/*       CGL127AM - COB Restructure - GL COB Optimisation Phase 1    */
/*       CCB009 - Journal files throughout close of business         */
/*       CEU028 - EMU GL Utilities                                   */
/*       CCB003 - COB Performance Enhancements - Task Split          */
/*                End Task Split                                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,GLC2605INT                                          */
 
/* Declare variables */
 
             DCL        VAR(&CNAME) TYPE(*CHAR) LEN(10) +
                          VALUE('GLC26     ')
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAQLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOURNAL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RECEIVER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CEU028*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CEU028*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CEU028*/
             DCL        VAR(&CEU028) TYPE(*CHAR) LEN(1)               /*CEU028*/
             DCL        VAR(&RECORD) TYPE(*DEC) LEN(10 0)                               /*CGL127AM*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                      CCB009*/
/**Declare*variable*CCB009*-*flag*for*switchable*feature************/            /*CCB009 CGL127AM*/
/*                                                                      CCB009*/
/**********  DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)            */            /*CCB009 CGL127AM*/
/**********  DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)           */            /*CCB009 CGL127AM*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,GLC2605MPS                                          */
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('GLC2605 - Batch Transaction File Split +
                          - End Task Split') TOMSGQ(MRUNQ)
/*                                                                      CCB009*/
/***Check*for*Switchable*feature*CCB009.****************************/            /*CCB009 CGL127AM*/
/*                                                                      CCB009*/
/**********  CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                         */            /*CCB009 CGL127AM*/
/**/                                                                  /*CEU028*/
/** Check if SAR CEU028 EMU GL Utilities is installed                 /*CEU028*/
/**/                                                                  /*CEU028*/
             CHGVAR     VAR(&SARD) VALUE('CEU028')                    /*CEU028*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*KEY' &SARD &FMT)   /*CEU028*/
                                                                      /*CEU028*/
             IF         COND((&RTCD *NE ' ') *AND (&RTCD *NE '*NRF')) +
                          THEN(GOTO CMDLBL(ABNOR))                    /*CEU028*/
             IF         COND(&RTCD *EQ ' ') THEN(CHGVAR VAR(&CEU028) +
                          VALUE('Y'))                                 /*CEU028*/
 
/* Call program to update Manual Posting trailer and header */
 
             CLRPFM     FILE(MANPOZZ)
             CPYF       FROMFILE(GLBATHPA) TOFILE(QTEMP/GLBATHPA) +
                          FROMMBR(*ALL) TOMBR(*FIRST) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                               /*AR1091153*/
             OVRDBF     FILE(GLBATHPA) TOFILE(GLBATHPA) MBR(*ALL)
/**********  RTVMBRD    FILE(GLBATHPA) MBR(BATCH00001) +           */                  /*AR1091153*/
/**********               NBRCURRCD(&RECORD)                       */         /*CGL127AM AR1091153*/
             RTVMBRD    FILE(QTEMP/GLBATHPA) NBRCURRCD(&RECORD)                        /*AR1091153*/
             IF         COND(&RECORD *NE 0) THEN(DO)                                    /*CGL127AM*/
             CALL       PGM(GL0265)
             ENDDO                                                                      /*CGL127AM*/
             DLTF       FILE(QTEMP/GLBATHPA)                                           /*AR1091153*/
 
/* Check if error */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
/**/                                                                  /*CEU028*/
/**  Call PGM/EU0750 to update PF/MANPOZZ if CEU028 is installed      /*CEU028*/
/**/                                                                  /*CEU028*/
             IF         COND(&CEU028 *EQ 'Y') THEN(DO) +
                                                                      /*CEU028*/
                           CALL  PGM(EU0750)                          /*CEU028*/
                                                                      /*CEU028*/
                           IF    COND(%SWITCH(XXXXXX11)) THEN(DO)     /*CEU028*/
                                 GOTO       CMDLBL(ABNOR)             /*CEU028*/
                           ENDDO                                      /*CEU028*/
                                                                      /*CEU028*/
                           CLRPFM EUPOSTZZ                            /*CEU028*/
                                                                      /*CEU028*/
             ENDDO                                                    /*CEU028*/
 
/* Determine full JLIB and DTAQLIB library name */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&JLIB) VALUE(&SYSID *CAT 'JLIB')
             CHGVAR     VAR(&DTAQLIB) VALUE(&SYSID *CAT 'XLIB')
 
/* Define journal and receiver name */
 
             CHGVAR     VAR(&JOURNAL) VALUE('J' *CAT &CNAME)
             CHGVAR     VAR(&RECEIVER) VALUE('JR' *CAT &CNAME)
 
/*                                                                      CCB009*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),****/            /*CCB009 CGL127AM*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)       */            /*CCB009 CGL127AM*/
/**Delete*journal/receiver**/                                                           /*CGL127AM*/
 
/**********  ENDJRNPF   FILE(*ALL) JRN(&JLIB/&JOURNAL)             */                   /*CGL127AM*/
/**********  MONMSG     MSGID(CPF7032 CPF9801)                     */                   /*CGL127AM*/
 
/**********  DLTJRN     JRN(&JLIB/&JOURNAL)                        */                   /*CGL127AM*/
/**********  MONMSG     MSGID(CPF2105 CPF9801)                     */                   /*CGL127AM*/
 
/**Delete*journal*receiver*without*any*display*if*not*fully*saved**/                    /*CGL127AM*/
 
/**********  CHGJOB     INQMSGRPY(*DFT)                            */                   /*CGL127AM*/
 
/**********  DLTJRNRCV  JRNRCV(&JLIB/&RECEIVER)                    */                   /*CGL127AM*/
/**********  MONMSG     MSGID(CPF2105 CPF9801)                     */                   /*CGL127AM*/
 
/**********  CHGJOB     INQMSGRPY(*RQD)                            */                   /*CGL127AM*/
/**********  ENDDO                                                 */            /*CCB009 CGL127AM*/
 
/* Delete main data queue */
 
             DLTDTAQ    DTAQ(&DTAQLIB/BATCHSERVE)
             MONMSG     MSGID(CPF2105 CPF9801)
 
/* Retrieve first member description */
 
             RTVMBRD    FILE(GLBATHPD) RTNMBR(&MEMBER)
 
/* Delete sub-task data queue */
 
 LOOP:       DLTDTAQ    DTAQ(&DTAQLIB/&MEMBER)
             MONMSG     MSGID(CPF2105 CPF9801)
 
/* Retrieve next member description */
 
             RTVMBRD    FILE(GLBATHPD) MBR(&MEMBER *NEXT) +
                          RTNMBR(&MEMBER)
             MONMSG     MSGID(CPF3049) EXEC(GOTO CMDLBL(REMOVE))
 
/* Loop for all members in driving file */
 
             GOTO       CMDLBL(LOOP)
 
/* Remove all members from driving and trailer file */
 
 REMOVE:     RMVM       FILE(GLBATHPD) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(GLBATHPA) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
 
             GOTO       CMDLBL(END)
 
 
 ABNOR:      SNDPGMMSG  MSG('Program GLC2605 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,GLC2605END                                          */
 
             ENDPGM
