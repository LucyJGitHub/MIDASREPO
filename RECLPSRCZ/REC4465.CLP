/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE CI Account details extract for Co-Sign')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4465 - CI Account Details Extract for Co-Sign            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG3415            Date 19Jul04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Prev Amend No. 142089             Date 14Feb00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CEU025             Date 31Aug98              */
/*                      118134             Date 02Jun97              */
/*                      CRT003  *CREATE    Date 22JUL96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG3415 - Remove C8PF extract. New LF C8PF in xxDVLIB to be */
/*                 adapted for use by Co-sign.                       */
/*       142089 - Co-sign file GWJ39P layout differs from RECICSPD.  */
/*                RECICSPD is re-loaded by this process so clear     */
/*                first.                                             */
/*                RECIEUPD is only ever written to by EU0140, EU     */
/*                mapping, so clearing it here will lose all details.*/
/*       CEU025 - EMU Midas-Cahier Interface                         */
/*       118134 - Correct ABNOR processing to ensure termination.    */
/*       CRT003 - Cashier Interface                                  */
/*                                                                   */
/********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(50)
/*/COPY WNCPYSRC,REC4465001                                          */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CEU025*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CEU025*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CEU025*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CEU025*/
             DCL        VAR(&CEU025) TYPE(*CHAR) LEN(1) VALUE('N')    /*CEU025*/
/*/COPY WNCPYSRC,REC4465002                                          */
 
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/**/
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
               CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             ENDDO
/*/COPY WNCPYSRC,REC4465003                                          */
/**/                                                                  /*CEU025*/
/* Check if CEU025 *ON */                                             /*CEU025*/
/**/                                                                  /*CEU025*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CEU025*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CEU025*/
             CHGVAR     VAR(&SAR) VALUE('CEU025')                     /*CEU025*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CEU025*/
             IF         COND(&RTCD *EQ '       ') +
                  THEN(CHGVAR VAR(&CEU025) VALUE('Y'))                /*CEU025*/
             IF         COND(&RTCD *NE '       ' *AND +
                  &RTCD *NE '*NRF   ') THEN(DO)                       /*CEU025*/
                  CHGJOB     SWS(XXXXXX11)                            /*CEU025*/
                  GOTO       CMDLBL(ABNOR)                            /*CEU025*/
                  ENDDO                                               /*CEU025*/
/*/COPY WNCPYSRC,REC4465004                                          */
 
/**Clear*C8PF*(required*for*co-sign)*before*re-build.*****/                   /*142089*/ /*BUG3415*/
/************CLRPFM*C8PF                                                   */ /*142089*/ /*BUG3415*/
             CLRPFM RECICSPD                                          /*142089*/
/**/
 
             CALL       PGM(RE4465)
/**/                                                                  /*CEU025*/
/* If SAR CEU025 is *ON, clear PF/RECIEUPD */                         /*CEU025*/
/**/                                                                  /*CEU025*/
/*/COPY WNCPYSRC,REC4465006                                          */
/********** IF COND(&CEU025 *EQ 'Y') THEN(CLRPFM RECIEUPD) /*CEU025*/ /*142089*/
/*/COPY WNCPYSRC,REC4465007                                          */
 
 /* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
/*  */                                                                /*142089*/
             CPYF       FROMFILE(RECICSPD) TOFILE(GWJ39P) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*142089*/
/*  */                                                                /*142089*/
/*/COPY WNCPYSRC,REC4465005                                          */
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('Account Details Extract Processing +
                          for Co-Sign ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG  MSGID(CPF2469)  EXEC(DO)                         /*118134*/
                SNDPGMMSG  MSG('Account Details Extract Processing +
                          for Co-Sign ended abnormally') +
                          TOMSGQ(QSYSOPR)                             /*118134*/
             ENDDO                                                    /*118134*/
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
