/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT NON-AUTHORISED PAYMENTS REPORT')             */
/*********************************************************************/
/*                                                                   */
/*       Midas      FUNDS TRANSFER MODULE                        */
/*                                                                   */
/*       FTC0231    NON-AUTHORISED PAYMENTS                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. BUG25160A         Date  18Aug09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01117            DATE  19AUG91              */
/*                                                                   */
/*********************************************************************/
/*       BUG25160A - Apply fix 229655                                */
/*       229655 - Integrate RFT/CCT unauthorised report              */
/*        S01117 - NEW SOURCE BASED ON FTC0230 FOR REL10             */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
/**/
        DCL   VAR(&TYPE)  TYPE(*CHAR)   LEN(1)
        DCL   VAR(&MEM)   TYPE(*CHAR)   LEN(50)
        DCL   VAR(&RSEQ)  TYPE(*CHAR)   LEN(5)
        DCL   VAR(&RLEV)  TYPE(*CHAR)   LEN(1)
        DCL   VAR(&RENT)  TYPE(*CHAR)   LEN(3)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
        SNDPGMMSG MSG('FT0231 - Non-authorised payments report') +
             TOMSGQ(MRUNQ)
/**/
/** Check if LDA Data area exists and create it if not **/
/**/
        CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
        MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                   DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                   VALUE(' ') TEXT('Midas SD LOCAL +
                   DATA AREA EQUIVALENT') AUT(*USE))
/**/
        CHGJOB SWS(00000000)
/**/
/** set up override **/
/**/
          IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)
             OVRDBF     FILE(NONAUBB) TOFILE(NONAUOB) POSITION(*KEY +
                          1 *N &RENT)
             OPNDBF     FILE(NONAUBB) OPTION(*INP)
             MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(NONAUBB) +
                          POSITION(*END))
             ENDDO
             ELSE       CMD(OVRDBF FILE(NONAUBB) TOFILE(NONAUOB))
/**/
        CALL PGM(FT0230) PARM(&TYPE &RSEQ &RLEV &RENT 'O')
        IF   COND(%SWITCH(XXXXXX11))   THEN(GOTO DBERR)                                   /*229655*/
/**/                                                                                      /*229655*/
/** set up override for RFT/CCT report */                                                 /*229655*/
/**/                                                                                      /*229655*/
/**/
             IF         COND((&RENT *NE 'ALL') *AND (&RENT *NE '   +
                          ')) THEN(DO)                                                    /*229655*/
             OVRDBF     FILE(FT101HLF) TOFILE(FT101HLG) POSITION(*KEY +
                          1 *N &RENT)                                                     /*229655*/
             OVRDBF     FILE(FT102HLF) TOFILE(FT102HLG) POSITION(*KEY +
                          1 *N &RENT)                                                     /*229655*/
             OPNDBF     FILE(FT101HLF) OPTION(*INP)                                       /*229655*/
             MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(FT101HLF) +
                          POSITION(*END))                                                 /*229655*/
             OPNDBF     FILE(FT102HLF) OPTION(*INP)                                       /*229655*/
             MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(FT102HLF) +
                          POSITION(*END))                                                 /*229655*/
             ENDDO                                                                        /*229655*/
             ELSE       (DO)                                                              /*229655*/
                OVRDBF FILE(FT101HLF) TOFILE(FT101HLG)                                    /*229655*/
                OVRDBF FILE(FT101HLF) TOFILE(FT101HLG)                                    /*229655*/
             ENDDO                                                                        /*229655*/
/**/                                                                                      /*229655*/
        CALL PGM(FT0231) PARM(&TYPE &RSEQ &RLEV &RENT 'O')                                /*229655*/
/**/                                                                                      /*229655*/
DBERR:                                                                                    /*229655*/
/**   DATABASE ERROR HANDLING   **/
/**/
        IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
             RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                   TOPGMQ(*EXT) TOMSGQ(MOPERQ)
        ENDDO
/**/
/** delete overrides **/
/**/
             DLTOVR     FILE(NONAUBB)
             MONMSG     MSGID(CPF9841)
             DLTOVR     FILE(FT101HLF)                                                    /*229655*/
             MONMSG     MSGID(CPF9841)                                                    /*229655*/
             DLTOVR     FILE(FT102HLF)                                                    /*229655*/
             MONMSG     MSGID(CPF9841)                                                    /*229655*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
        ENDPGM
