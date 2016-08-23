/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Check and correct unjournalled files ctl')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC2463 - Check and Correct Unjournalled Files              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG7935            Date 17Aug05              */
/*       Prev Amend No. BUG7388            Date 31May05              */
/*                      BUG6546            Date 21Apr05              */
/*                      CSC023             Date 02Feb04              */
/*                      CSC018             Date 31May03              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      206437             Date  3Jul02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSC011             Date 07Jul02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009 *CREATE     Date 21Jun00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG7935 - Problem with BUG6546, CNAM and CSEQ must be       */
/*                 received into the program                         */
/*       BUG7388 - Do not wait until the submitted jobs              */
/*                 have all completed.                               */
/*       BUG6546 - Do not end SCC2463 until the submitted jobs       */
/*                 have all completed.                               */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CSC018 - Journaling options for high availability           */
/*       206437 - Change parameter JOBMSGQFL to *WRAP                */
/*       CSC011 - 24x7 Availability:                                 */
/*                - Journal the DZLIB.                               */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       CCB009 - Journal files throughout close of business.        */
/*                                                                   */
/*********************************************************************/
/**********  PGM */                                                                      /*BUG7935*/
             PGM        PARM(&CNAM &CSEQ)                                                /*BUG7935*/
 
/*/COPY WNCPYSRC,SCC2463INT                                          */
 
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                     /*CSC018*/
/*******     DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                             BUG6546*BUG7388*/
/*******     DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                             BUG6546*BUG7388*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                                   /*BUG7935*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                                   /*BUG7935*/
/*******     DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1) VALUE(' ')                   BUG6546*BUG7388*/
/*******     DCL        VAR(&JRNSTS) TYPE(*CHAR) LEN(14)                           BUG6546*BUG7388*/
/*******     DCL        VAR(&JRN1) TYPE(*CHAR) LEN(1)                              BUG6546*BUG7388*/
/*******     DCL        VAR(&JRN2) TYPE(*CHAR) LEN(1)                              BUG6546*BUG7388*/
/*******     DCL        VAR(&JRN3) TYPE(*CHAR) LEN(1)                              BUG6546*BUG7388*/
/*******     DCL        VAR(&JRN4) TYPE(*CHAR) LEN(1)                              BUG6546*BUG7388*/
/*******     DCL        VAR(&JRN5) TYPE(*CHAR) LEN(1)                              BUG6546*BUG7388*/
/*******     DCL        VAR(&JRN6) TYPE(*CHAR) LEN(1)                              BUG6546*BUG7388*/
/*******     DCL        VAR(&JRN7) TYPE(*CHAR) LEN(1)                              BUG6546*BUG7388*/
/*******     DCL        VAR(&JRN8) TYPE(*CHAR) LEN(1)                              BUG6546*BUG7388*/
/*******     DCL        VAR(&JRN9) TYPE(*CHAR) LEN(1)                              BUG6546*BUG7388*/
/*******     DCL        VAR(&JRN10) TYPE(*CHAR) LEN(1)                             BUG6546*BUG7388*/
/*******     DCL        VAR(&JRN11) TYPE(*CHAR) LEN(1)                             BUG6546*BUG7388*/
/*******     DCL        VAR(&JRN12) TYPE(*CHAR) LEN(1)                             BUG6546*BUG7388*/
/*******     DCL        VAR(&JRN13) TYPE(*CHAR) LEN(1)                             BUG6546*BUG7388*/
/*******     DCL        VAR(&JRN14) TYPE(*CHAR) LEN(1)                             BUG6546*BUG7388*/
/*                                                                                        /*CSC018*/
/* Declare variables for switchable feature CSC018,                                       /*CSC018*/
/* (Journaling options for high availability)                                             /*CSC018*/
/*                                                                                        /*CSC018*/
/*/COPY SDCPYSRC,SDSVALDCL                                           */                   /*CSC018*/
             DCL        VAR(&CSC018) TYPE(*CHAR) LEN(7)                                   /*CSC018*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)                                  /*CSC018*/
             DCL        VAR(&JRNDA6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&JRNDQ6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/***Check the status of restart flag                                               BUG6546*BUG7388*/
/*******     CALL       PGM(CB0160) PARM(&CNAM &CSEQ &BUSY)                        BUG6546*BUG7388*/
/*******                                                                           BUG6546*BUG7388*/
/***If*this is not a restart                                                       BUG6546*BUG7388*/
/*******     IF         COND(&BUSY *EQ 'N') THEN(DO)                               BUG6546*BUG7388*/
/*******     CHGDTAARA  DTAARA(SDSTAT (86 14)) +                                   BUG6546*BUG7388*/
/*******                  VALUE('NNNNNNNNNNNNNN')                                  BUG6546*BUG7388*/
/***Update status to 'Y' in case component fails to update the file                BUG6546*BUG7388*/
/*******     CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'Y')                          BUG6546*BUG7388*/
/*******     ENDDO                                                                 BUG6546*BUG7388*/
/*******                                                                           BUG6546*BUG7388*/
/**Retrieve the data area flags for status of journalling jobs                     BUG6546*BUG7388*/
/*******                                                                           BUG6546*BUG7388*/
/*******     RTVDTAARA  DTAARA(SDSTAT (86 14)) RTNVAR(&JRNSTS)                     BUG6546*BUG7388*/
/*******     CHGVAR     VAR(&JRN1) VALUE(%SST(&JRNSTS 1 1))                        BUG6546*BUG7388*/
/*******     CHGVAR     VAR(&JRN2) VALUE(%SST(&JRNSTS 2 1))                        BUG6546*BUG7388*/
/*******     CHGVAR     VAR(&JRN3) VALUE(%SST(&JRNSTS 3 1))                        BUG6546*BUG7388*/
/*******     CHGVAR     VAR(&JRN4) VALUE(%SST(&JRNSTS 4 1))                        BUG6546*BUG7388*/
/*******     CHGVAR     VAR(&JRN5) VALUE(%SST(&JRNSTS 5 1))                        BUG6546*BUG7388*/
/*******     CHGVAR     VAR(&JRN6) VALUE(%SST(&JRNSTS 6 1))                        BUG6546*BUG7388*/
/*******     CHGVAR     VAR(&JRN7) VALUE(%SST(&JRNSTS 7 1))                        BUG6546*BUG7388*/
/*******     CHGVAR     VAR(&JRN8) VALUE(%SST(&JRNSTS 8 1))                        BUG6546*BUG7388*/
/*******     CHGVAR     VAR(&JRN9) VALUE(%SST(&JRNSTS 9 1))                        BUG6546*BUG7388*/
/*******     CHGVAR     VAR(&JRN10) VALUE(%SST(&JRNSTS 10 1))                      BUG6546*BUG7388*/
/*******     CHGVAR     VAR(&JRN11) VALUE(%SST(&JRNSTS 11 1))                      BUG6546*BUG7388*/
/*******     CHGVAR     VAR(&JRN12) VALUE(%SST(&JRNSTS 12 1))                      BUG6546*BUG7388*/
/*******     CHGVAR     VAR(&JRN13) VALUE(%SST(&JRNSTS 13 1))                      BUG6546*BUG7388*/
/*******     CHGVAR     VAR(&JRN14) VALUE(%SST(&JRNSTS 14 1))                      BUG6546*BUG7388*/
/*******                                                                           BUG6546*BUG7388*/
/*/COPY WNCPYSRC,SCC2463MPS                                          */
/*                                                                                        /*CSC018*/
/** Check for Switchable feature CSC018.                                                  /*CSC018*/
/*                                                                                        /*CSC018*/
             CALL       PGM(AOSARDR0) PARM(&CSC018 '*VERIFY' +
                          'CSC018' &AOFMT)                                                /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If feature CSC018 is present,                                                         /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND(&CSC018 *EQ '       ') THEN(DO)                              /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Get the high availability system values */                                            /*CSC018*/
                                                                                          /*CSC018*/
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                          'HighAvlJrnDtaaras' &SVAL1 +
                          'HighAvlJrnDtaqueues' &SVAL2 &SVALK3 +
                          &SVAL3 &SVALK4 &SVAL4 &SVALK5 &SVAL5 +
                          &SVALK6 &SVAL6 &SVALK7 &SVAL7 &SVALK8 +
                          &SVAL8 &SVALK9 &SVAL9 &SVALK10 &SVAL10)                         /*CSC018*/
                                                                                          /*CSC018*/
/* If there is an error finding any system value then end abnormally */                   /*CSC018*/
                                                                                          /*CSC018*/
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*CSC018*/
/*                                                                                        /*CSC018*/
/** Check whether data area journaling is required.                                       /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&JRNDA6) VALUE(%SST(&SVAL1 1 1))                             /*CSC018*/
/*                                                                                        /*CSC018*/
/** Check whether data queue journaling is required.                                      /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&JRNDQ6) VALUE(%SST(&SVAL2 1 1))                             /*CSC018*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
 
/* Retrieve the Midas system prefix */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
 
/* Submit the DMLIB job */
 
             CHGVAR     VAR(&LIB) VALUE(&PREFIX *CAT 'DMLIB')
 
/************SBMJOB     CMD(CALL PGM(SCC2464) PARM(&LIB)) JOB(&LIB) +                     /*CPK014*/
/************             JOBQ(MEODQ)                                                     /*CPK014*/
/**********  SBMJOB     CMD(CALL PGM(SCC2464) PARM(&LIB)) JOB(&LIB) +
/**********               JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD)                 /*CPK014*/ /*206437*/
/************SBMJOB     CMD(CALL PGM(SCC2464) PARM(&LIB)) JOB(&LIB) +                     /*CSC023*/
/************             JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) +                          /*CSC023*/
/************             JOBMSGQFL(*WRAP)                                     /*206437*/ /*CSC023*/
/*******     IF         COND(&JRN1 *NE 'Y') THEN(DO)                               BUG6546*BUG7388*/
             SBMJOB     CMD(CALL PGM(SCC2464) PARM(&LIB)) JOB(&LIB) +
                          JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) +
                          JOBMSGQFL(*WRAP) OUTQ(*JOBD)                                    /*CSC023*/
/*******     ENDDO                                                                 BUG6546*BUG7388*/
 
/* Submit the DPLIB job */
 
             CHGVAR     VAR(&LIB) VALUE(&PREFIX *CAT 'DPLIB')
 
/************SBMJOB     CMD(CALL PGM(SCC2464) PARM(&LIB)) JOB(&LIB) +                     /*CPK014*/
/************             JOBQ(MEODQ)                                                     /*CPK014*/
/**********  SBMJOB     CMD(CALL PGM(SCC2464) PARM(&LIB)) JOB(&LIB) +
/**********               JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD)                 /*CPK014*/ /*206437*/
/************SBMJOB     CMD(CALL PGM(SCC2464) PARM(&LIB)) JOB(&LIB) +                     /*CSC023*/
/************             JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) +                          /*CSC023*/
/************             JOBMSGQFL(*WRAP)                                     /*206437*/ /*CSC023*/
/*******     IF         COND(&JRN2 *NE 'Y') THEN(DO)                               BUG6546*BUG7388*/
             SBMJOB     CMD(CALL PGM(SCC2464) PARM(&LIB)) JOB(&LIB) +
                          JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) +
                          JOBMSGQFL(*WRAP) OUTQ(*JOBD)                                    /*CSC023*/
/*******     ENDDO                                                                 BUG6546*BUG7388*/
 
/* Submit the DTALIB job */
 
             CHGVAR     VAR(&LIB) VALUE(&PREFIX *CAT 'DTALIB')
 
/************SBMJOB     CMD(CALL PGM(SCC2464) PARM(&LIB)) JOB(&LIB) +                     /*CPK014*/
/************             JOBQ(MEODQ)                                                     /*CPK014*/
/**********  SBMJOB     CMD(CALL PGM(SCC2464) PARM(&LIB)) JOB(&LIB) +
/**********               JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD)                 /*CPK014*/ /*206437*/
/************SBMJOB     CMD(CALL PGM(SCC2464) PARM(&LIB)) JOB(&LIB) +                     /*CSC023*/
/************             JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) +                          /*CSC023*/
/************             JOBMSGQFL(*WRAP)                                     /*206437*/ /*CSC023*/
/*******     IF         COND(&JRN3 *NE 'Y') THEN(DO)                               BUG6546*BUG7388*/
             SBMJOB     CMD(CALL PGM(SCC2464) PARM(&LIB)) JOB(&LIB) +
                          JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) +
                          JOBMSGQFL(*WRAP) OUTQ(*JOBD)                                    /*CSC023*/
/*******     ENDDO                                                                 BUG6546*BUG7388*/
 
/* Submit the DZLIB job */                                                                /*CSC011*/
                                                                                          /*CSC011*/
             CHGVAR     VAR(&LIB) VALUE(&PREFIX *CAT 'DZLIB ')                            /*CSC011*/
                                                                                          /*CSC011*/
/**********  SBMJOB     CMD(CALL PGM(SCC2464) PARM(&LIB)) JOB(&LIB) +
/**********               JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD)                 /*CSC011*/ /*206437*/
/************SBMJOB     CMD(CALL PGM(SCC2464) PARM(&LIB)) JOB(&LIB) +                     /*CSC023*/
/************             JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) +                          /*CSC023*/
/************             JOBMSGQFL(*WRAP)                                     /*206437*/ /*CSC023*/
/*******     IF         COND(&JRN4 *NE 'Y') THEN(DO)                               BUG6546*BUG7388*/
             SBMJOB     CMD(CALL PGM(SCC2464) PARM(&LIB)) JOB(&LIB) +
                          JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) +
                          JOBMSGQFL(*WRAP) OUTQ(*JOBD)                                    /*CSC023*/
/*******     ENDDO                                                                 BUG6546*BUG7388*/
                                                                                          /*CSC011*/
/*/COPY WNCPYSRC,SCC2463MPE                                          */
/*                                                                                        /*CSC018*/
/* If Feature CSC018 is 'on' (Journaling options for high availability)                   /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND(&CSC018 *EQ '       ') THEN(DO)                              /*CSC018*/
/*                                                                                        /*CSC018*/
/* If data area journaling is required,                                                   /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND(&JRNDA6 *EQ 'Y') THEN(DO)                                    /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Call program to journal data areas in xxDMLIB.                                        /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&LIB) VALUE(&PREFIX *CAT 'DMLIB   ')                          /*CSC018*/
             CHGVAR     VAR(&JOB) VALUE('DA' *CAT %SST(&LIB 1 8))                         /*CSC018*/
/************SBMJOB     CMD(CALL PGM(SCC2467) PARM(&LIB)) JOB(&JOB) +                     /*CSC023*/
/************             JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD)                 /*CSC018*/ /*CSC023*/
/*******     IF         COND(&JRN5 *NE 'Y') THEN(DO)                               BUG6546*BUG7388*/
             SBMJOB     CMD(CALL PGM(SCC2467) PARM(&LIB)) JOB(&JOB) +
                          JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) OUTQ(*JOBD)                /*CSC023*/
/*******     ENDDO                                                                 BUG6546*BUG7388*/
/*                                                                                        /*CSC018*/
/*  Call program to journal data areas in xxDPLIB.                                        /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&LIB) VALUE(&PREFIX *CAT 'DPLIB   ')                          /*CSC018*/
             CHGVAR     VAR(&JOB) VALUE('DA' *CAT %SST(&LIB 1 8))                         /*CSC018*/
/************SBMJOB     CMD(CALL PGM(SCC2467) PARM(&LIB)) JOB(&JOB) +                     /*CSC023*/
/************             JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD)                 /*CSC018*/ /*CSC023*/
/*******     IF         COND(&JRN6 *NE 'Y') THEN(DO)                               BUG6546*BUG7388*/
             SBMJOB     CMD(CALL PGM(SCC2467) PARM(&LIB)) JOB(&JOB) +
                          JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) OUTQ(*JOBD)                /*CSC023*/
/*******     ENDDO                                                                 BUG6546*BUG7388*/
/*                                                                                        /*CSC018*/
/*  Call program to journal data areas in xxDTALIB.                                       /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&LIB) VALUE(&PREFIX *CAT 'DTALIB  ')                          /*CSC018*/
             CHGVAR     VAR(&JOB) VALUE('DA' *CAT %SST(&LIB 1 8))                         /*CSC018*/
/************SBMJOB     CMD(CALL PGM(SCC2467) PARM(&LIB)) JOB(&JOB) +                     /*CSC023*/
/************             JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD)                 /*CSC018*/ /*CSC023*/
/*******     IF         COND(&JRN7 *NE 'Y') THEN(DO)                               BUG6546*BUG7388*/
             SBMJOB     CMD(CALL PGM(SCC2467) PARM(&LIB)) JOB(&JOB) +
                          JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) OUTQ(*JOBD)                /*CSC023*/
/*******     ENDDO                                                                 BUG6546*BUG7388*/
/*                                                                                        /*CSC018*/
/*  Call program to journal data areas in xxXLIB.                                         /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&LIB) VALUE(&PREFIX *CAT 'XLIB    ')                          /*CSC018*/
             CHGVAR     VAR(&JOB) VALUE('DA' *CAT %SST(&LIB 1 8))                         /*CSC018*/
/************SBMJOB     CMD(CALL PGM(SCC2467) PARM(&LIB)) JOB(&JOB) +                     /*CSC023*/
/************             JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD)                 /*CSC018*/ /*CSC023*/
/*******     IF         COND(&JRN8 *NE 'Y') THEN(DO)                               BUG6546*BUG7388*/
             SBMJOB     CMD(CALL PGM(SCC2467) PARM(&LIB)) JOB(&JOB) +
                          JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) OUTQ(*JOBD)                /*CSC023*/
/*******     ENDDO                                                                 BUG6546*BUG7388*/
/*                                                                                        /*CSC018*/
/*  Call program to journal data areas in xxJLIB.                                         /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&LIB) VALUE(&PREFIX *CAT 'JLIB    ')                          /*CSC018*/
             CHGVAR     VAR(&JOB) VALUE('DA' *CAT %SST(&LIB 1 8))                         /*CSC018*/
/************SBMJOB     CMD(CALL PGM(SCC2467) PARM(&LIB)) JOB(&JOB) +                     /*CSC023*/
/************             JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD)                 /*CSC018*/ /*CSC023*/
/*******     IF         COND(&JRN9 *NE 'Y') THEN(DO)                               BUG6546*BUG7388*/
             SBMJOB     CMD(CALL PGM(SCC2467) PARM(&LIB)) JOB(&JOB) +
                          JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) OUTQ(*JOBD)                /*CSC023*/
/*******     ENDDO                                                                 BUG6546*BUG7388*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/*******                                                                           BUG6546*BUG7388*/
/*******     ELSE       CMD(DO)                                                    BUG6546*BUG7388*/
/*******     CHGDTAARA  DTAARA(SDSTAT (90 5)) +                                    BUG6546*BUG7388*/
/*******                  VALUE('YYYYY')                                           BUG6546*BUG7388*/
/*******     ENDDO                                                                 BUG6546*BUG7388*/
/*                                                                                        /*CSC018*/
/* If data queue journaling is required,                                                  /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND(&JRNDQ6 *EQ 'Y') THEN(DO)                                    /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Call program to journal data queues in xxDMLIB.                                       /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&LIB) VALUE(&PREFIX *CAT 'DMLIB   ')                          /*CSC018*/
             CHGVAR     VAR(&JOB) VALUE('DQ' *CAT %SST(&LIB 1 8))                         /*CSC018*/
/************SBMJOB     CMD(CALL PGM(SCC2471) PARM(&LIB)) JOB(&JOB) +                     /*CSC023*/
/************             JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD)                 /*CSC018*/ /*CSC023*/
/*******     IF         COND(&JRN10 *NE 'Y') THEN(DO)                              BUG6546*BUG7388*/
             SBMJOB     CMD(CALL PGM(SCC2471) PARM(&LIB)) JOB(&JOB) +
                          JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) OUTQ(*JOBD)                /*CSC023*/
/*******     ENDDO                                                                 BUG6546*BUG7388*/
/*                                                                                        /*CSC018*/
/*  Call program to journal data queues in xxDPLIB.                                       /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&LIB) VALUE(&PREFIX *CAT 'DPLIB   ')                          /*CSC018*/
             CHGVAR     VAR(&JOB) VALUE('DQ' *CAT %SST(&LIB 1 8))                         /*CSC018*/
/************SBMJOB     CMD(CALL PGM(SCC2471) PARM(&LIB)) JOB(&JOB) +                     /*CSC023*/
/************             JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD)                 /*CSC018*/ /*CSC023*/
/*******     IF         COND(&JRN11 *NE 'Y') THEN(DO)                              BUG6546*BUG7388*/
             SBMJOB     CMD(CALL PGM(SCC2471) PARM(&LIB)) JOB(&JOB) +
                          JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) OUTQ(*JOBD)                /*CSC023*/
/*******     ENDDO                                                                 BUG6546*BUG7388*/
/*                                                                                        /*CSC018*/
/*  Call program to journal data queues in xxDTALIB.                                      /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&LIB) VALUE(&PREFIX *CAT 'DTALIB  ')                          /*CSC018*/
             CHGVAR     VAR(&JOB) VALUE('DQ' *CAT %SST(&LIB 1 8))                         /*CSC018*/
/************SBMJOB     CMD(CALL PGM(SCC2471) PARM(&LIB)) JOB(&JOB) +                     /*CSC023*/
/************             JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD)                 /*CSC018*/ /*CSC023*/
/*******     IF         COND(&JRN12 *NE 'Y') THEN(DO)                              BUG6546*BUG7388*/
             SBMJOB     CMD(CALL PGM(SCC2471) PARM(&LIB)) JOB(&JOB) +
                          JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) OUTQ(*JOBD)                /*CSC023*/
/*******     ENDDO                                                                 BUG6546*BUG7388*/
/*                                                                                        /*CSC018*/
/*  Call program to journal data queues in xxXLIB.                                        /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&LIB) VALUE(&PREFIX *CAT 'XLIB    ')                          /*CSC018*/
             CHGVAR     VAR(&JOB) VALUE('DQ' *CAT %SST(&LIB 1 8))                         /*CSC018*/
/************SBMJOB     CMD(CALL PGM(SCC2471) PARM(&LIB)) JOB(&JOB) +                     /*CSC023*/
/************             JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD)                 /*CSC018*/ /*CSC023*/
/*******     IF         COND(&JRN13 *NE 'Y') THEN(DO)                              BUG6546*BUG7388*/
             SBMJOB     CMD(CALL PGM(SCC2471) PARM(&LIB)) JOB(&JOB) +
                          JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) OUTQ(*JOBD)                /*CSC023*/
/*******     ENDDO                                                                 BUG6546*BUG7388*/
/*                                                                                        /*CSC018*/
/*  Call program to journal data queues in xxJLIB.                                        /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&LIB) VALUE(&PREFIX *CAT 'JLIB    ')                          /*CSC018*/
             CHGVAR     VAR(&JOB) VALUE('DQ' *CAT %SST(&LIB 1 8))                         /*CSC018*/
/************SBMJOB     CMD(CALL PGM(SCC2471) PARM(&LIB)) JOB(&JOB) +                     /*CSC023*/
/************             JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD)                 /*CSC018*/ /*CSC023*/
/*******     IF         COND(&JRN14 *NE 'Y') THEN(DO)                              BUG6546*BUG7388*/
             SBMJOB     CMD(CALL PGM(SCC2471) PARM(&LIB)) JOB(&JOB) +
                          JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) OUTQ(*JOBD)                /*CSC023*/
/*******     ENDDO                                                                 BUG6546*BUG7388*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/*******                                                                           BUG6546*BUG7388*/
/*******     ELSE       CMD(DO)                                                    BUG6546*BUG7388*/
/*******     CHGDTAARA  DTAARA(SDSTAT (95 5)) +                                    BUG6546*BUG7388*/
/*******                  VALUE('YYYYY')                                           BUG6546*BUG7388*/
/*******     ENDDO                                                                 BUG6546*BUG7388*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/*******                                                                           BUG6546*BUG7388*/
/*******     ELSE       CMD(DO)                                                    BUG6546*BUG7388*/
/*******     CHGDTAARA  DTAARA(SDSTAT (90 10)) +                                   BUG6546*BUG7388*/
/*******                  VALUE('YYYYYYYYYY')                                      BUG6546*BUG7388*/
/*******     ENDDO                                                                 BUG6546*BUG7388*/
 
/************GOTO       CMDLBL(END)                                                BUG6546*BUG7388*/
/************GOTO*******CMDLBL(ENDLOOP)********************************************BUG6546*BUG7388*/
             GOTO       CMDLBL(END)                                                      /*BUG7388*/
 
 ABNOR:
/*/COPY WNCPYSRC,SCC2463ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            SCC2463 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
/*******                                                                           BUG6546*BUG7388*/
/*******     GOTO       CMDLBL(END)                                                BUG6546*BUG7388*/
/*ENDLOOP:                                                                         BUG6546*BUG7388*/
/*******                                                                           BUG6546*BUG7388*/
/*******     DLYJOB     20                                                         BUG6546*BUG7388*/
/*******     RTVDTAARA  DTAARA(SDSTAT (86 14)) RTNVAR(&JRNSTS)                     BUG6546*BUG7388*/
/*******     IF         COND(&JRNSTS *NE 'YYYYYYYYYYYYYY') THEN(GOTO +             BUG6546*BUG7388*/
/*******                  CMDLBL(ENDLOOP))                                         BUG6546*BUG7388*/
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,SCC2463END                                          */
 
             ENDPGM
