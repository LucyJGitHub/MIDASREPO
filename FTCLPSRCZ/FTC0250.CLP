/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT INCOMING PAYMENTS BY SENDER (BRCA)')         */
/********************************************************************/
/*                                                                  */
/*       Midas     - FUNDS TRANSFER MODULE                      */
/*                                                                  */
/*       FTC0250  - CL COMPONENT TO CONTROL FT0250                  */
/*                - INCOMING PAYMENT SUMMARY BY SENDER              */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E32919            DATE  26/06/91            */
/*       PREV AMEND NO. S01117            DATE   20SEP90            */
/*                      S01194            DATE   20SEP90            */
/*                                                                  */
/********************************************************************/
/*       E32919 - EXTRACT FILE INPAYEX NOW GENERATED WITH  FULL     */
/*                ADDRESS OF SENDER AND BENEFICIARY TO PROVIDE      */
/*                CORRECT SEQUENCING                                */
/*       S01117 - RELEASE 10 MULTIBRANCHING CHANGES                 */
/*       S01194 - STANDING DATA CHANGES                             */
/********************************************************************/
/**          PGM        PARM(&TYPE)                                  /*S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)               /*S01117*/
 
/**     DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)                    /*S01194*/
        DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                    /*S01194*/
        DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
        DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                     /*S01117*/
        DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                     /*S01117*/
        DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                     /*S01117*/
        DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)                  /*S01117*/
        DCL        VAR(&BORO) TYPE(*CHAR) LEN(1) VALUE('B')          /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
                                                                     /*S01117*/
/**/
        CHGJOB     SWS(XXXXXX00)
                                                                     /*S01117*/
        CHGVAR     VAR(&TYPE) VALUE(%SST(&RPARM 3 1))                /*S01117*/
                                                                     /*S01117*/
        IF (&TYPE = '3') THEN(DO)                                    /*S01117*/
        CHGVAR     VAR(&TYPE) VALUE(' ')                             /*S01117*/
        ENDDO                                                        /*S01117*/
/**/                                                                 /*S01194*/
/** CHECK IF LDA DATA AREA EXISTS AND CREATE IT IF NOT **/           /*S01194*/
/**/                                                                 /*S01194*/
        CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)                         /*S01194*/
        MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                   DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                   VALUE(' ') TEXT('Midas SD LOCAL +
                   DATA AREA EQUIVALENT') AUT(*USE))                 /*S01194*/
/*E32919*/
/* CLEAR EXTRACT FILE INPAYEX */
             CLRPFM     FILE(INPAYEX)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('REPORT IS ALREADY IN USE PLEASE WAIT +
                          AND TRY AGAIN') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(WAIT)
             ENDDO
 
 
/*GENERATE INPAYEX EXTRACT RECORDS*/
 
             CALL PGM(FT0249) PARM(&TYPE)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
             SNDPGMMSG  MSG('CALL TO EXTRACT PROGRAM FT0249 FROM +
                          FTC0251 ENDED IN ERROR') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             GOTO       CMDLBL(END)
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(END))
/*E32919*/
 
/***Override*if*required***/                                         /*S01117*/
/**     IF (&TYPE = '1') THEN(DO)                                    /*S01117*/
/**     OVRDBF INPASA INPAUT                                         /*S01117*/
/**     ENDDO                                                        /*S01117*/
 
/**     IF (&TYPE = '2') THEN(DO)                                    /*S01117*/
/**     OVRDBF INPASA INPNAS                                         /*S01117*/
/**     ENDDO                                                        /*S01117*/
 
 
/**/                                                                 /*S01117*/
/** SET UP OVER RIDES **/                                            /*S01117*/
/**/                                                                 /*S01117*/
         IF         COND(&TYPE *EQ ' ') THEN(DO)                     /*S01117*/
         IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)
           OVRDBF     FILE(INPASABB) POSITION(*KEY 1 *N &RENT)       /*S01117*/
           OPNDBF     FILE(INPASABB) OPTION(*INP)                    /*S01117*/
           MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(INPASABB) +
                          POSITION(*END))                            /*S01117*/
         ENDDO                                                       /*S01117*/
         ENDDO                                                       /*S01117*/
                                                                     /*S01117*/
         IF         COND(&TYPE *EQ '1') THEN(DO)                     /*S01117*/
         IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)
           OVRDBF   FILE(INPASABB) TOFILE(INPAUTBB) +
                      POSITION(*KEY 1 *N &RENT)                      /*S01117*/
           OPNDBF     FILE(INPASABB) OPTION(*INP)                    /*S01117*/
           MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(INPASABB) +
                         POSITION(*END))                             /*S01117*/
         ENDDO                                                       /*S01117*/
         ELSE       CMD(OVRDBF FILE(INPASABB) TOFILE(INPAUTBB))      /*S01117*/
         ENDDO                                                       /*S01117*/
                                                                     /*S01117*/
         IF         COND(&TYPE *EQ '2') THEN(DO)                     /*S01117*/
         IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)
           OVRDBF     FILE(INPASABB) TOFILE(INPNASBB) +
                          POSITION(*KEY 1 *N &RENT)                  /*S01117*/
           OPNDBF     FILE(INPASABB) OPTION(*INP)                    /*S01117*/
           MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(INPASABB) +
                           POSITION(*END))                           /*S01117*/
         ENDDO                                                       /*S01117*/
         ELSE       CMD(OVRDBF FILE(INPASABB) TOFILE(INPNASBB))      /*S01117*/
         ENDDO                                                       /*S01117*/
/**/
/**/
/** CALL PROGRAM **/
/**/
/**          CALL       PGM(FT0250) PARM(&TYPE)                      /*S01117*/
             CALL       PGM(FT0250) PARM(&RSEQ &RLEV &RENT &TYPE +
                          &BORO)                                     /*S01117*/
 
/** Delete*Overrides*if*present **/                                  /*S01117*/
/**          IF         COND(&TYPE = '1' *OR &TYPE = '2') THEN(DO)   /*S01117*/
/**     DLTOVR INPASA                                                /*S01117*/
/**     ENDDO                                                        /*S01117*/
             CLOF       OPNID(INPASABB)                              /*S01117*/
             MONMSG     MSGID(CPF4520)                               /*S01117*/
/**/                                                                 /*S01117*/
/** Delete overrides */                                              /*S01117*/
/**/                                                                 /*S01117*/
             DLTOVR     FILE(INPASABB)                               /*S01117*/
             MONMSG     MSGID(CPF9841)                               /*S01117*/
 
/**/
/** CHECK FOR DATABASE ERRORS TRAPPED BY THE PROGRAM        **/
/**/
                                                             /*E32919*/
END:
                                                             /*E32919*/
        IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
/**          RTVDTAARA   DTAARA(LDA (134 44))   RTNVAR(&MEM)         /*S01194*/
             RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&MEM)         /*S01194*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                    TOPGMQ(*EXT) TOMSGQ(MOPERQ)
        ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*E32919*/
/* CLEAR EXTRACT FILE INPAYEX */
             CLRPFM     FILE(INPAYEX)
/*E32919*/
                                                                      /*E32919*/
WAIT:
                                                                      /*E32918*/
             ENDPGM
