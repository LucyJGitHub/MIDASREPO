/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Deal number input gaps - input cycle')       */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0904 - DEAL NUMBER INPUT GAPS - INPUT CYCLE             */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Prev Amend No. 169253             Date 15May02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      E312               Date 09Apr90              */
/*                      S01117             Date 22Sep89              */
/*                       S01194       DATE 22/09/89                 */
/*                       S01179       DATE 14/09/88                 */
/*                                                                  */
/*------------------------------------------------------------------*/
/*       MD046248 - Finastra Rebranding                              */
/*       169253 - Call DL0850 before calling DL0851. New PF is       */
/*                created and used for DL0850.                       */
/*       E312    -  CREATE LDA IN QTEMP                             */
/*       E266    -  PROG SHOULD RECEIVE 3 ENTRY PARAMETERS          */
/*       S01117  -  MULTIBRANCHING/RCF CHANGES                      */
/*       S01194  -  NEW STANDING DATA (RELEASE 10)                  */
/*       S01179  -  AS400 CONVERSION                                */
/*                                                                  */
/********************************************************************/
/************PGM                                                        S01117*/
 
/************PGM PARM(&RSEQ &RLEV )                           /*S01117**E264*/
             PGM PARM(&RSEQ &RLEV &RENT)                              /*E264*/
/**/
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B) */     /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code */            /*E264*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                 /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
/*********** DCLDTAARA  DTAARA(LDA)                                     S01179*/
/*                                                                       *E312*/
/*   CREATE LOCAL DATA AREA                                         */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area')
             MONMSG     MSGID(CPF0000) /* Monitor here to prevent +
                          error during re-routing of job */
                                                                        /*E312*/
/**/
             CHGJOB     SWS(10000000)
/**/
             SNDMSG     MSG('DEAL NUMBERS INPUT GAPS REPORT - INPUT +
                        CYCLE') TOMSGQ(MRUNQ)
/*********** OVRDBF     FILE(TABLE)   TOFILE(TABDLEI)                 /*S01194*/
/*********** CALL       PGM(DL0851)                                   /*S01117*/
/*********** DLTOVR     FILE(TABLE)                                   /*S01194*/
             CLRPFM     FILE(DLNOTRPD) MBR(DLNOTRPD)                  /*169253*/
             CLRPFM     FILE(DLGAPNPD)                                /*169253*/
             CALL       PGM(DL0850)                                   /*169253*/
             CALL       PGM(DL0851) PARM(&RSEQ)                       /*S01117*/
             CLRPFM     FILE(DLGAPNPD)                                /*169253*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(RETURN)
             ELSE       CMD(DO)
/**/
/*                 FOR DATABASE ERRORS RECOVER DATA FROM LDA     */
/**/
ERROR:          IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**************    RCVDTAARA  DTAARA(LDA)                             /*S01179*/
                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                /*S01179*/
/***************   CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))      /*S01117*/
                   CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))      /*S01117*/
/***************   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) /*S01117*/
                   SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                               TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                ENDDO
/**/
                ELSE  CMD(DO)
                   CHGVAR     VAR(&MSG) VALUE('FILE CONTROLS OUT OF BALANCE +
                            - DL0851')
                   SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ)            +
                               MSGTYPE(*INFO)
               ENDDO
            ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
