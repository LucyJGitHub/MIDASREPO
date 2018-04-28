/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Interest and Cost of Accruals Rpt Control')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Lending Module                                      */
/*                                                                   */
/*       LEC6900 - Lending Interest and Cost of Funds Accruals       */
/*                 Report Control                                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 138289             Date 20Jun98              */
/*                      CAC001 *CREATE     Date 01FEB96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       138289 - COF Accruals reports do not reconcile usefully.    */
/*                Create new extract and reports based on LEC0806,   */
/*                LE1110 and LE112* Interest Accruals reports.       */
/*       CAC001 - Profit Centre Accounting Development:              */
/*                New CL program.                                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(128)
             DCL        VAR(&QRYSEL) TYPE(*CHAR) LEN(50)
/**/
/**  Global Monitor Message:                                         */
/**   If an unmonitorred message occurs perform error processing     */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             CALL       PGM(AOMMODR0) PARM('*MSG  ' '*FIRST' &MMOD)
/**/
/**  If Analytical Accounting is not present, then end the program */
/**/
             IF         COND(%SST(&MMOD 100 1) *EQ 'N') THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('LE +
                             Interest and Cost of Funds Accrual Report +
                             not allowed.  Analytical Accounting is not +
                             present') TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
                GOTO       CMDLBL(END)
             ENDDO
/**/
/**  Create LDA if it does not already exist */
/**/
             SNDMSG     MSG('LEC6900 - Lending Interest and Cost of +
                          Funds Accruals Report') TOMSGQ(MRUNQ)
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('MIDAS SD AS400 LOCAL +
                          DATA AREA EQUIVALENT'))
/**/
/**  Select only directly funded loans */
/**/
             CHGVAR     VAR(&QRYSEL) VALUE('FPRC *NE " "')
/**/
/**  Select records for particular branch if requested */
/**/
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)
                CHGVAR     VAR(%SST(&QRYSEL 14 19)) VALUE('*AND BRCA +
                             *EQ "' *CAT &RENT *CAT '"')
             ENDDO
             OPNQRYF    FILE((LECLONL0)) QRYSLT(&QRYSEL) KEYFLD(*FILE)
/**/
/**  Call report program  */
/**/
             CHGJOB     SWS(00000000)
             CALL       PGM(LE6900) PARM(&RSEQ &RLEV &RENT)
/**/
/**  Database error processing */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
/**********  GOTO       CMDLBL(END) **/                              /*138289*/
                                                                     /*138289*/
/**     Clear COF extract files                                       *138289*/
/**/
             CLRPFM     FILE(LEACFHH)                                /*138289*/
             CLRPFM     FILE(LEACFAC)                                /*138289*/
             CLRPFM     FILE(LEACFZZ)                                /*138289*/
/**/
             OVRDBF     FILE(CLOANC) TOFILE(CLOAN) SHARE(*NO)        /*138289*/
/**     Call extract program.                                         *138289*/
             CALL       PGM(LE6910)
/*/COPY WNCPYSRC,LEC6900001                                          */
/**/
/**  Extract process complete not OK                                 /*138289*/
     IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)                     /*138289*/
             GOTO       CMDLBL(ABNOR)                                /*138289*/
             ENDDO                                                   /*138289*/
     ELSE       CMD(DO)                                              /*138289*/
/**/
/**  Extract process complete OK                                     /*138289*/
/**/
             IF COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') THEN(DO)       /*138289*/
/*    Report is at System level                                      /*138289*/
/**********           CALL    PGM(LE6922) PARM(&RSEQ)                /*138289*/
             ENDDO                                                   /*138289*/
/**/
        IF         COND(&RLEV *EQ 'C') THEN(DO)                      /*138289*/
/* Position file to the particular company                           /*138289*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                /*138289*/
                 OVRDBF    FILE(SLACFL1) POSITION(*KEY 1 LEACFACF +
                           &RENT)                                    /*138289*/
                 OPNDBF    FILE(SLACFL1) OPTION(*ALL)                /*138289*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                   /*138289*/
                     DLTOVR     FILE(SLACFL1)                        /*138289*/
                 ENDDO                                               /*138289*/
                 CLOF OPNID(SLACFL1)                                 /*138289*/
                 MONMSG     MSGID(CPF0000)                           /*138289*/
             ENDDO                                                   /*138289*/
/**********           CALL    PGM(LE6921) PARM(&RSEQ &RENT)          /*138289*/
        ENDDO                                                        /*138289*/
/**/
        IF         COND(&RLEV *EQ 'B') THEN(DO)                      /*138289*/
/* Position file to the particulay branch                            /*138289*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                /*138289*/
                 OVRDBF    FILE(SLACF) POSITION(*KEY 1 LEACFACF +
                           &RENT)                                    /*138289*/
                 OPNDBF    FILE(SLACF) OPTION(*ALL)                  /*138289*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                   /*138289*/
                     DLTOVR     FILE(SLACF)                          /*138289*/
                 ENDDO                                               /*138289*/
                 CLOF OPNID(SLACF)                                   /*138289*/
                 MONMSG     MSGID(CPF0000)                           /*138289*/
             ENDDO                                                   /*138289*/
                      CALL    PGM(LE6920) PARM(&RSEQ &RENT)          /*138289*/
        ENDDO                                                        /*138289*/
/**/
/**     Clear COF extract files                                       *138289*/
/**/
             CLRPFM     FILE(LEACFHH)                                /*138289*/
             CLRPFM     FILE(LEACFAC)                                /*138289*/
             CLRPFM     FILE(LEACFZZ)                                /*138289*/
/**/
/**/
     ENDDO                                                           /*138289*/
/**/
/**/
       IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(END))     /*138289*/
 /**/
 ABNOR:      DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          LEC6900 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 /**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
             CLOF       OPNID(LECLONL0)
             MONMSG     MSGID(CPF0000)
/**/
             CLOF       OPNID(SLACFL1)                               /*138289*/
             MONMSG     MSGID(CPF0000)                               /*138289*/
             CLOF       OPNID(SLACF)                                 /*138289*/
             MONMSG     MSGID(CPF0000)                               /*138289*/
             ENDPGM
