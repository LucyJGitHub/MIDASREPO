/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Beginning of database save')                 */
/*********************************************************************/
/*                                                                   */
/*        Midas - Restart Recovery Module                            */
/*                                                                   */
/*          SCC1710 - BEGINNING OF BUSINESS DATABASE SAVE            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CSC043             Date 18Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 02Feb04              */
/*                      CSC020             Date 31Mar04              */
/*                         CSC018             Date 31May03           */
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*                         CPK014             Date 14Nov01           */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                         CCB009             Date 01Jun00           */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                         S01408             DATE 10MAY95           */
/*                         087987             DATE 23MAY95           */
/*                         081177             DATE 07MAR95           */
/*                         078087             DATE 24OCT94          */
/*                         S01375             DATE 03APR92          */
/*                         E35124             DATE 29JAN92          */
/*                         S01345             DATE 06NOV91          */
/*                         S01343             DATE 15AUG91          */
/*                         E19080             DATE 11NOV89          */
/*                         S01179             DATE 12/09/88         */
/*                         S01173             DATE 30/06/88         */
/*                         E80902             DATE 05/06/86         */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CSC043 - MidasPlus IASP Enablement                          */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*     CSC018 - Journaling options for High Availability            */
/*     CPK014 - Submit jobs with user *JOBD                         */
/*     CCB009 - Journal files throughout close of business          */
/*     S01408 - Addition of core hook SCC1710MP1                    */
/*     087987 - Autocob parameter is now redundent on call to       */
/*              CB0602X.                                            */
/*     081177 - Use Job Description library list instead of current */
/*              library list when submitting job                    */
/*     078087 - Set logging levels so that all relevant info is     */
/*              logged but the spool file does not exceed the max   */
/*              size specified by the system.                       */
/*          S01375 - Changed for Auto Close of Business             */
/*          E35124 - Display a screen to tell user when journalling */
/*                   has completed.                                 */
/*          S01345 - JOURNALLING SYSTEM RE-WRITE.                   */
/*          S01343 - SC/RR/SD MODULE RENAME PROJECT.                */
/*                   - SCC1710 RENAMED FROM SDC1710.                */
/*                   - SCC1712 RENAMED FROM SDC1712.                */
/*                   - SCC1716 RENAMED FROM SDC1716.                */
/*          E19080 - POSITION 68 OF JNSTAT NOT BEING UPDATED WITH   */
/*                   CORRESPONDING VALUE                            */
/*          S01179 - AS400 CONVERSION                               */
/*          S01173 - CREATE JOURNAL/RECEIVER IN SPECIFIED ASP       */
/*          E80902 - IF JOURNAL DOES NOT EXIST THEN PROGRAM TRIES   */
/*                   TO REMOVE LIBRARY LIST ENTRY BEFORE ADDING IT. */
/*                                                                  */
/********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*   INITIAL PROCESSING                                             */
/**/
             DCL        VAR(&SMSG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&BIND) TYPE(*CHAR) LEN(1) VALUE('B')
             DCL        VAR(&TIND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(8) VALUE('  JLIB  ')
/**/
/**********  DCLDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(200)             /*S01179*/
/**********  DCLDTAARA  DTAARA(SDSTAT)                              *  *S01179*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
/**********  DCLDTAARA  DTAARA(MNATN)                               *  *S01179*/
             DCL        VAR(&MNATN) TYPE(*CHAR) LEN(5)                /*S01179*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)             /*E35124*/
             DCL        VAR(&CB_RTN_CDE) TYPE(*CHAR) LEN(7)           /*S01375*/
             DCL        VAR(&CB_AUTO) TYPE(*CHAR) LEN(111)            /*S01375*/
             DCL        VAR(&LOG) TYPE(*CHAR) LEN(10)                 /*078087*/
/*/COPY SDCPYSRC,SDSVALDCL                                           */                   /*CSC018*/
             DCL        VAR(&SUPPUPD) TYPE(*CHAR) LEN(20)                                 /*CSC018*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/*                                                                                        /*CSC018*/
/* Declare variables for CSC018 - journaling options for High Availability                /*CSC018*/
/*                                                                                        /*CSC018*/
             DCL        VAR(&CSC018) TYPE(*CHAR) LEN(7)                                   /*CSC018*/
             DCL        VAR(&THRES6) TYPE(*CHAR) LEN(10)                                  /*CSC018*/
             DCL        VAR(&MAXOP6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&RMVIN6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&MINFI6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)                                  /*CSC018*/
             DCL        VAR(&THRESHOLDB) TYPE(*DEC) LEN(15 0)                             /*CSC018*/
             DCL        VAR(&THRESHOLDK) TYPE(*DEC) LEN(15 0)                             /*CSC018*/
             DCL        VAR(&SIZOPT1) TYPE(*CHAR) LEN(10)                                 /*CSC018*/
             DCL        VAR(&SIZOPT2) TYPE(*CHAR) LEN(10)                                 /*CSC018*/
             DCL        VAR(&SIZOPT3) TYPE(*CHAR) LEN(10)                                 /*CSC018*/
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(150)                                    /*CSC018*/
/*/COPY WNCPYSRC,SCC1710003                                          */
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC043*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC043*/
/*/COPY GPCPYSRCG,GPSVALDCL  */                                                           /*CSC043*/
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/*                                                                                        /*CSC043*/
/** Get the global IASP system values */                                                  /*CSC043*/
/*                                                                                        /*CSC043*/
             CALL       PGM(GPAOSVALR0) PARM(&RSVALRTNC +
                          'IASPinstallation' &SVAL1 +
                          'IASPgroup' &SVAL2 &SVALK3 +
                          &SVAL3 &SVALK4 &SVAL4 &SVALK5 &SVAL5 +
                          &SVALK6 &SVAL6 &SVALK7 &SVAL7 &SVALK8 +
                          &SVAL8 &SVALK9 &SVAL9 &SVALK10 &SVAL10)                         /*CSC043*/
/*                                                                                        /*CSC043*/
/** Check whether system is in IASP environment. */                                       /*CSC043*/
/*                                                                                        /*CSC043*/
              CHGVAR     VAR(&IASP_YN) VALUE(%SST(&SVAL1 1 1))                            /*CSC043*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
/*                                                                                        /*CSC043*/
/** Get name of IASP. */                                                                  /*CSC043*/
/*                                                                                        /*CSC043*/
              CHGVAR     VAR(&IASP) VALUE(%SST(&SVAL2 1 10))                              /*CSC043*/
                                                                                          /*CSC043*/
             ENDDO                                                                        /*CSC043*/
                                                                                          /*CSC043*/
/*                                                                                        /*CSC018*/
/*  Check for Switchable feature CSC018.                                                  /*CSC018*/
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
                             'HighAvlRcvSizeOption' &SVAL1 +
                             'HighAvlJrnRcvThld' &SVAL2 +
                             'HighAvlRmvIntJrnEnt' &SVAL3 +
                             'HighAvlMinFixLenJrnE' &SVAL4 +
                             &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                             &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                             &SVALK10 &SVAL10)                                            /*CSC018*/
                                                                                          /*CSC018*/
/* If there is an error finding any system value then end abnormally */                   /*CSC018*/
                                                                                          /*CSC018*/
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))
/*                                                                                        /*CSC018*/
/*  Determine journal receiver threshold.                                                 /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&THRES6) VALUE(%SST(&SVAL2 1 10))                            /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If threshold is blank on the system value file.                                       /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&THRES6 *EQ '          ') THEN(DO)                          /*CSC018*/
/*                                                                                        /*CSC018*/
/*  set the value to a default of 1.5 gigabytes,                                          /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&THRES6) VALUE('0001500000')                                /*CSC018*/
               CHGVAR     VAR(%SST(&SVAL2 1 10)) VALUE('0001500000')                      /*CSC018*/
/*                                                                                        /*CSC018*/
/*  and update the system value.                                                          /*CSC018*/
/*                                                                                        /*CSC018*/
               CALL       PGM(SD009510) PARM('HighAvlJrnRcvThld  ' +
                            &SVAL2 &SUPPUPD)                                              /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Calculate threshold value in KB.                                                      /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&THRESHOLDK) VALUE(&THRES6)                                  /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Multiply by 1000 to give value in bytes.                                              /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&THRESHOLDB) VALUE(&THRESHOLDK * 1000)                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If threshold defined on the system value is too big,                                  /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&THRES6 *GE '1000000000') THEN(DO)                          /*CSC018*/
/*                                                                                        /*CSC018*/
/*  set the value to a default of 1.5 gigabytes,                                          /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&THRES6) VALUE('0001500000')                                /*CSC018*/
               CHGVAR     VAR(&THRESHOLDK) VALUE(1500000)                                 /*CSC018*/
               CHGVAR     VAR(&THRESHOLDB) VALUE(1500000000)                              /*CSC018*/
/*                                                                                        /*CSC018*/
/*  and update the system value.                                                          /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(%SST(&SVAL2 1 10)) VALUE('0001500000')                      /*CSC018*/
/*                                                                                        /*CSC018*/
               CALL       PGM(SD009510) PARM('HighAvlJrnRcvThld  ' +
                            &SVAL2 &SUPPUPD)                                              /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Determine whether *MAXOPT1 or *MAXOPT2 are to be used.                                /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&MAXOP6) VALUE(%SST(&SVAL1 1 1))                             /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Determine whether internal journal entries are to be removed.                         /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&RMVIN6) VALUE(%SST(&SVAL3 1 1))                             /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If value is blank on the system value file.                                           /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&RMVIN6 *EQ ' ') THEN(DO)                                   /*CSC018*/
/*                                                                                        /*CSC018*/
/*  set a default value of 'N',                                                           /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&RMVIN6) VALUE('N')                                         /*CSC018*/
/*                                                                                        /*CSC018*/
/*  and update the system value file.                                                     /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(%SST(&SVAL3 1 1)) VALUE('N')                                /*CSC018*/
               CALL       PGM(SD009510) PARM('HighAvlRmvIntJrnEnt' +
                            &SVAL3 &SUPPUPD)                                              /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Determine whether miminal fixed length journal entries are                            /*CSC018*/
/*  required.  (Not recommended!!)                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&MINFI6) VALUE(%SST(&SVAL4 1 1))                             /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If value is blank on the system value file.                                           /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&MINFI6 *EQ ' ') THEN(DO)                                   /*CSC018*/
/*                                                                                        /*CSC018*/
/*  set a default value of 'N',                                                           /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&MINFI6) VALUE('N')                                         /*CSC018*/
/*                                                                                        /*CSC018*/
/*  and update the system value.                                                          /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(%SST(&SVAL4 1 1)) VALUE('N')                                /*CSC018*/
               CALL       PGM(SD009510) PARM('HighAvlMinFixLenJrnE' +
                            &SVAL4 &SUPPUPD)                                              /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Construct the variable for receiver size options.                                     /*CSC018*/
/*  Insert *MAXOPT1 or *MAXOPT2, if required.                                             /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&MAXOP6 *EQ '2') THEN(DO)                                   /*CSC018*/
               CHGVAR     VAR(&SIZOPT1) VALUE('*MAXOPT2  ')                               /*CSC018*/
              ENDDO                                                                       /*CSC018*/
              ELSE       CMD(DO)                                                          /*CSC018*/
               IF         COND(&MAXOP6 *EQ '1') THEN(DO)                                  /*CSC018*/
                CHGVAR     VAR(&SIZOPT1) VALUE('*MAXOPT1  ')                              /*CSC018*/
               ENDDO                                                                      /*CSC018*/
               ELSE       CMD(DO)                                                         /*CSC018*/
                CHGVAR     VAR(&SIZOPT1) VALUE('          ')                              /*CSC018*/
               ENDDO                                                                      /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Insert *RMVINTENT, if required.                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&RMVIN6 *EQ 'Y') THEN(DO)                                   /*CSC018*/
               CHGVAR     VAR(&SIZOPT2) VALUE('*RMVINTENT')                               /*CSC018*/
              ENDDO                                                                       /*CSC018*/
              ELSE       CMD(DO)                                                          /*CSC018*/
               CHGVAR     VAR(&SIZOPT2) VALUE('          ')                               /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Insert *MINFIXLEN, if required.                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&MINFI6 *EQ 'Y') THEN(DO)                                   /*CSC018*/
               CHGVAR     VAR(&SIZOPT3) VALUE('*MINFIXLEN')                               /*CSC018*/
              ENDDO                                                                       /*CSC018*/
              ELSE       CMD(DO)                                                          /*CSC018*/
               CHGVAR     VAR(&SIZOPT3) VALUE('          ')                               /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If no options are required, insert '*NONE'.                                           /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND((&SIZOPT1 *EQ '          ') *AND +
                          (&SIZOPT2 *EQ '          ') *AND +
                          (&SIZOPT3 *EQ '          ')) THEN(DO)                           /*CSC018*/
               CHGVAR     VAR(&SIZOPT1) VALUE('*NONE')                                    /*CSC018*/
              ENDDO                                                                       /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
/**/
             SNDPGMMSG  MSG('Beginning of Business Database Save') +
                        TOMSGQ(MRUNQ)
/**/
/*   CHECK THAT THE REQUIRED DATA AREAS EXIST                                 */
/**/
/* JNSTAT */
/**/
             CHKOBJ     OBJ(JNSTAT) OBJTYPE(*DTAARA)
               MONMSG     MSGID(CPF9801) EXEC(DO)
               CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                          - data area JNSTAT not found ')
               SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)
               CHGJOB     SWS(XXXXXX11)
               GOTO       CMDLBL(ENDPGM)
/**/
               ENDDO
/**/
/* MNATN */
/**/
             CHKOBJ     OBJ(MNATN) OBJTYPE(*DTAARA)
               MONMSG     MSGID(CPF9801) EXEC(DO)
               CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                          - data area MNATN not found ')
               SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)
               CHGJOB     SWS(XXXXXX11)
               GOTO       CMDLBL(ENDPGM)
/**/
             ENDDO
/*/COPY WNCPYSRC,SCC1710004                                          */
/**/
/* SDSTAT */
/**/
             CHKOBJ     OBJ(SDSTAT) OBJTYPE(*DTAARA)
               MONMSG     MSGID(CPF9801) EXEC(DO)
               CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                          - data area SDSTAT not found ')
               SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)
               CHGJOB     SWS(XXXXXX11)
               GOTO       CMDLBL(ENDPGM)
/**/
             ENDDO
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/**/
/* END JOURNALLING PF TO ENABLE DELETION */
/**/
/*/COPY WNCPYSRC,SCC1710005                                          */
             ENDJRNPF   FILE(*ALL) JRN(ICJRN)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
/**/
/* DELETE JOURNAL & JOURNAL RECEIVERS                                         */
/**/
             DLTJRN     JRN(ICJRN)
/**/
/* IF JOURNAL NOT FOUND, PROCESSING CONTINUES. IF ANY OTHER ERROR             */
/* OCCURS, JOURNAL IS NOT DELETED, ERROR MSG IS SENT & PROGRAM ENDS           */
/**/
             MONMSG     MSGID(CPF2105) EXEC(GOTO CMDLBL(LOW1))
             MONMSG     MSGID(CPF0000) EXEC(DO)
               CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                          - Journal cannot be deleted')
               SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)
               CHGJOB     SWS(XXXXXX11)
               GOTO       CMDLBL(ENDPGM)
/**/
             ENDDO
/*/COPY WNCPYSRC,SCC1710006                                          */
/**/
/**ADD*A*REPLY*LIST*ENTRY*SO*THAT*"RECEIVER*NEVER*HAD*FULL*SAVE"*****  *E80902*/
/**MESSAGES*ARE*ANSWERED*AUTOMATICALLY*BY*THE*PROGRAM,*THEN**********  *E80902*/
/**REMOVE*THE*ENTRY*AFTER*RECEIVERS*HAVE*BEEN*DELETED****************  *E80902*/
/**/                                                                  /*E80902*/
/*           CHGJOB     INQMSGRPY(*SYSRPYL)   */                      /*E80902*/
/*           ADDRPYLE   SEQNBR(3) MSGID(CPA7025) RPY(I)          */   /*E80902*/
/**/                                                                  /*E80902*/
/* CHANGE JOB ATTRIBUTES FOR INQMSGRPY SO THAT "RECEIVER NEVER HAD  *  *E80902*/
/* FULL SAVE" MESSAGES ARE ANSWERED AUTOMATICALLY BY THE PROGRAM,   *  *E80902*/
/* THEN CHANGE THE JOB AGAIN TO THE ORIGINAL STATE AFTER RECEIVERS  *  *E80902*/
/* HAVE BEEN DELETED                                                *  *E80902*/
/**/                                                                  /*E80902*/
LOW1:        CHGJOB     INQMSGRPY(*DFT)                               /*E80902*/
/**/
/* IF RECEIVERS NOT FOUND, PROCESSING CONTINUES. IF ANY OTHER ERROR           */
/* OCCURS, RECEIVERS NOT DELETED, ERROR MSG IS SENT & PROGRAM ENDS            */
/**/
/*/COPY WNCPYSRC,SCC1710007                                          */
/*OW1:       DLTJRNRCV  JRNRCV(ICRCV*)     */                         /*E80902*/
/*********** DLTJRNRCV  JRNRCV(ICRCV*) *********************************E80902**************CSC020*/
             DLTJRNRCV  JRNRCV(IR*)                                                       /*CSC020*/
             MONMSG     MSGID(CPF2105 CPF2125) EXEC(GOTO CMDLBL(ALC1))
             MONMSG     MSGID(CPF0000) EXEC(DO)
               CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                          - Receivers cannot be deleted')
               SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)
/*             RMVRPYLE   SEQNBR(3)                                 *  *E80902*/
               CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXX11)
               GOTO       CMDLBL(ENDPGM)
/**/
             ENDDO
/*/COPY WNCPYSRC,SCC1710008                                          */
/**/
/*LC1:       RMVRPYLE   SEQNBR(3)                                   *  *E80902*/
/*           CHGJOB     INQMSGRPY(*RQD)                             *  *E80902*/
ALC1:        CHGJOB     INQMSGRPY(*RQD)                               /*E80902*/
/**/
/*  OBTAIN LIBRARY ID FROM SDSTAT                                    */
/**/
/**********  RCVDTAARA  DTAARA(SDSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                /*S01179*/
             CHGVAR     VAR(%SUBSTRING(&LIB 1 2)) +
                          VALUE(%SUBSTRING(&SDSTAT 6 2))
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC1710MP1                                          */
                                                                      /*S01408*/
/**/
/*  CREATE THE NEW JOURNAL & RECEIVER(S) -                                    */
/***(A)*IF*DUAL*RECEIVERS*ARE*TO*BE*USED****************************************************CSC020*/
/*******************************************************************************************CSC020*/
/************RCVDTAARA**DTAARA(JNSTAT)**********************************S01179**************CSC020*/
/************RTVDTAARA**DTAARA(JNSTAT)*RTNVAR(&JNSTAT)******************S01179**************CSC020*/
/************IF*********COND(%SUBSTRING(&JNSTAT*70*1)**EQ*'Y')*THEN(DO)*********************CSC020*/
/*******************************************************************************************CSC020*/
/**COPY*WNCPYSRC,SCC1710009*****************************************************************CSC020*/
/**************CRTJRNRCV**JRNRCV(ICRCV001.&LIB)*TEXT('receiver*for*+************************CSC020*/
/*************************journal*icjrn')*******************************S01173**************CSC020*/
/**************CRTJRNRCV**JRNRCV(ICRCV002.&LIB)*TEXT('receiver*for*+************************CSC020*/
/*************************journal*icjrn')*******************************S01173**************CSC020*/
/**************CRTJRN*****JRN(ICJRN.&LIB)*JRNRCV(ICRCV001*ICRCV002)*****S01173**************CSC020*/
/************CRTJRNRCV**JRNRCV(&LIB/ICRCV001)*ASP(%SST(&JNSTAT*151*+************************CSC020*/
/*************************2))*TEXT('receiver*for*journal*icjrn')*+**************************CSC020*/
/***************************S01173**********************************************************CSC020*/
/************CRTJRNRCV**JRNRCV(&LIB/ICRCV002)*ASP(%SST(&JNSTAT*151*+************************CSC020*/
/*************************2))*TEXT('receiver*for*journal*icjrn')*+**************************CSC020*/
/***************************S01173**********************************************************CSC020*/
/************CRTJRN*****JRN(&LIB/ICJRN)*JRNRCV(ICRCV001*ICRCV002)*+*************************CSC020*/
/*************************ASP(%SST(&JNSTAT*149*2))***S01173*********************************CSC020*/
/**COPY*WNCPYSRC,SCC1710010*****************************************************************CSC020*/
/**************CHGVAR*****VAR(%SUBSTRING(&JNSTAT*68*1))*+***********************************CSC020*/
/*************************VALUE('Y')************************************E19080**************CSC020*/
/************CHGDTAARA**DTAARA(JNSTAT*(68*1))*VALUE('Y')****************E19080**************CSC020*/
/*******************************************************************************************CSC020*/
/************ENDDO**************************************************************************CSC020*/
/*******************************************************************************************CSC020*/
/***(B)*IF*SINGLE*RECEIVERS*ARE*TO*BE*USED**************************************************CSC020*/
/*******************************************************************************************CSC020*/
/************ELSE*******CMD(DO)*************************************************************CSC020*/
/**/
/*/COPY WNCPYSRC,SCC1710011                                          */
/*             CRTJRNRCV  JRNRCV(ICRCV001.&LIB) TEXT('receiver for +
                          journal icjrn')  */                         /*S01173*/
/*             CRTJRN     JRN(ICJRN.&LIB) JRNRCV(ICRCV001)  */        /*S01173*/
/*                                                                                        /*CSC018*/
/* If journal receiver size options are not being used,                                   /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND((&CSC018 *NE '       ') *OR ((&CSC018 +
                          *EQ '       ') *AND (&MAXOP6 *EQ ' '))) +
                          THEN(DO)                                                        /*CSC018*/
/************CRTJRNRCV**JRNRCV(&LIB/ICRCV001)*ASP(%SST(&JNSTAT*151*+************************CSC020*/
/*************************2))*TEXT('receiver*for*journal*icjrn')*+**************************CSC020*/
/***************************S01173**********************************************************CSC020*/
/************CRTJRN*****JRN(&LIB/ICJRN)*JRNRCV(ICRCV001)*+**********************************CSC020*/
/*************************ASP(%SST(&JNSTAT*149*2))***S01173*********************************CSC020*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
             CRTJRNRCV  JRNRCV(&LIB/IR00000001) ASP(*LIBASP) +
                          THRESHOLD(1500000) TEXT('receiver for +
                          journal icjrn')                                                 /*CSC043*/
             CRTJRN     JRN(&LIB/ICJRN) JRNRCV(IR00000001) +
                          ASP(*LIBASP)                                                    /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
             CRTJRNRCV  JRNRCV(&LIB/IR00000001) ASP(%SST(&JNSTAT 151 +
                          2)) THRESHOLD(1500000) TEXT('receiver for +
                          journal icjrn')                                                 /*CSC020*/
             CRTJRN     JRN(&LIB/ICJRN) JRNRCV(IR00000001) +
                          ASP(%SST(&JNSTAT 149 2))                                        /*CSC020*/
             ENDDO                                                                        /*CSC043*/
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
/* If journal receiver size options are being used,                                       /*CSC018*/
/*                                                                                        /*CSC018*/
             ELSE       CMD(DO)                                                           /*CSC018*/
/*                                                                                        /*CSC018*/
/* Create journal receiver with required threshold.                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*************CRTJRNRCV**JRNRCV(&LIB/ICRCV001)*ASP(%SST(&JNSTAT*151*+***********************CSC020*/
/*************************2))*THRESHOLD(&THRESHOLDK)*TEXT('receiver*+***********************CSC020*/
/*************************for*journal*ICJRN')***************************************CSC018**CSC020*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
              CRTJRNRCV  JRNRCV(&LIB/IR00000001) ASP(*LIBASP) +
                          THRESHOLD(&THRESHOLDK) TEXT('receiver +
                          for journal ICJRN')                                             /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
              CRTJRNRCV  JRNRCV(&LIB/IR00000001) ASP(%SST(&JNSTAT 151 +
                          2)) THRESHOLD(&THRESHOLDK) TEXT('receiver +
                          for journal ICJRN')                                             /*CSC020*/
             ENDDO                                                                        /*CSC043*/
/*                                                                                        /*CSC018*/
/* Create journal with required size options.                                             /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&CMD) VALUE(' ')                                             /*CSC018*/
/*************CHGVAR*****VAR(&CMD)*VALUE('CRTJRN*JRN('**CAT*&LIB**CAT*+*********************CSC020*/
/*************************'/ICJRN)*JRNRCV(ICRCV001)*ASP('**CAT*+****************************CSC020*/
/*************************%SST(&JNSTAT*149*2)**CAT*')*RCVSIZOPT('*+*************************CSC020*/
/**************************CAT*&SIZOPT1**BCAT*&SIZOPT2**BCAT*+******************************CSC020*/
/*************************&SIZOPT3**TCAT*')')**************************************CSC018***CSC020*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
             CHGVAR     VAR(&CMD) VALUE('CRTJRN JRN(' *CAT &LIB *CAT +
                          '/ICJRN) JRNRCV(IR00000001) ASP(*LIBASP) +
                          RCVSIZOPT(' *CAT &SIZOPT1 *BCAT &SIZOPT2 +
                          *BCAT &SIZOPT3 *TCAT ')')                                       /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
              CHGVAR     VAR(&CMD) VALUE('CRTJRN JRN(' *CAT &LIB *CAT +
                          '/ICJRN) JRNRCV(IR00000001) ASP(' *CAT +
                          %SST(&JNSTAT 149 2) *CAT ') RCVSIZOPT(' +
                          *CAT &SIZOPT1 *BCAT &SIZOPT2 *BCAT +
                          &SIZOPT3 *TCAT ')')                                             /*CSC020*/
             ENDDO                                                                        /*CSC043*/
              CALL       PGM(QCMDEXC) PARM(&CMD 150)                                      /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/*/COPY WNCPYSRC,SCC1710012                                          */
/************* CHGVAR     VAR(%SUBSTRING(&JNSTAT 68 1)) +
                          VALUE('N') ********/                        /*E19080*/
             CHGDTAARA  DTAARA(JNSTAT (68 1)) VALUE('N')              /*E19080*/
/**/
/************ENDDO**************************************************************************CSC020*/
/**/
/*  INITIALISE MNATN & JNSTAT DATA AREAS                                      */
/**/
/**********  RCVDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)                /*S01179*/
/**********  RCVDTAARA  DTAARA(MNATN)                               *  *S01179*/
             RTVDTAARA  DTAARA(MNATN) RTNVAR(&MNATN)                  /*S01179*/
/**/
             CHGVAR     VAR(&MNATN) VALUE('00001')
/**/
/************CHGVAR*****VAR(%SUBSTRING(&JNSTAT*1*20))*+*************************************CSC020*/
/*************************VALUE('ICRCV001**ICRCV001**')*************************************CSC020*/
             CHGVAR     VAR(%SUBSTRING(&JNSTAT 1 20)) +
                          VALUE('IR00000001IR00000001')                                   /*CSC020*/
/*/COPY WNCPYSRC,SCC1710001                                          */
             CHGVAR     VAR(%SUBSTRING(&JNSTAT 63 5)) +
                          VALUE('DB001')
/*/COPY WNCPYSRC,SCC1710002                                          */
             CHGVAR     VAR(%SUBSTRING(&JNSTAT 74 1)) +
                          VALUE('N')
             CHGVAR     VAR(%SUBSTRING(&JNSTAT 75 5)) +
                          VALUE('     ')
             CHGVAR     VAR(%SUBSTRING(&JNSTAT 81 1)) +
                          VALUE('N')
/**/
/**********  SNDDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             CHGDTAARA  DTAARA(JNSTAT) VALUE(&JNSTAT)                 /*S01179*/
/**********  SNDDTAARA  DTAARA(MNATN)                               *  *S01179*/
             CHGDTAARA  DTAARA(MNATN) VALUE(&MNATN)                   /*S01179*/
/**/
/***CALL*SDC1730*TO*START*JOURNALLING*THE*PHYSICAL*FILES*****/        /*S01345*/
/**/
/************CALL       PGM(SDC1730) **/                              /*S01345*/
/**/                                                                  /*S03145*/
/*  CALL SCJRN TO START JOURNALLING THE PHYSICAL FILES                /*S01345*/
/* CHANGE LOGGING LEVEL BEFORE CALLING THE JOURNAL PGM, AND  */       /*078087*/
/* RESET AFTERWARDS                                          */       /*078087*/
/**/                                                                  /*S03145*/
             RTVJOBA    LOGCLPGM(&LOG)                                /*078087*/
             CHGJOB     LOGCLPGM(*NO)                                 /*078087*/
/**/                                                                  /*S03145*/
             CALL       PGM(SCJRN)                                    /*S01345*/
             CHGJOB     LOGCLPGM(&LOG)                                /*078087*/
                                                                      /*078087*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO ENDPGM)
                                                                      /*E35124*/
/*  Inform the user that journalling is complete  */                  /*E35124*/
                                                                      /*E35124*/
             RTVMSG     MSGID(SCM0067) MSGF(MIDASMSG) MSG(&MESSAGE)   /*E35124*/
             MONMSG     MSGID(CPF0000)                                /*E35124*/
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)     /*E35124*/
             MONMSG     MSGID(CPF0000)                                /*E35124*/
             RTVMSG     MSGID(SCM0068) MSGF(MIDASMSG) MSG(&MESSAGE)   /*E35124*/
             MONMSG     MSGID(CPF0000)                                /*E35124*/
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)     /*E35124*/
             MONMSG     MSGID(CPF0000)                                /*E35124*/
             CALL       PGM(SCC0010) PARM('SCC1710' 'BLANK' ' ')      /*E35124*/
             MONMSG     MSGID(CPF0000)                                /*E35124*/
             ENDDO                                                    /*CCB009*/
                                                                      /*E35124*/
/**/
/***CALL*SDC1716*TO*CHANGE*JOURNAL*RECEIVERS                          /*S01343*/
/*  CALL SCC1716 TO CHANGE JOURNAL RECEIVERS                          /*S01343*/
/**/
/*****       CALL       PGM(SDC1716) PARM(0)                          /*S01343*/
             CALL       PGM(SCC1716) PARM(0)                          /*S01343*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO ENDPGM)
/**/
/***CALL*SDC1712*TO SAVE THE MASTER LIBRARY                           /*S01343*/
/*****       CALL       PGM(SDC1712) PARM(&BIND &TIND)                /*S01343*/
/* */                                                                 /*S01375*/
/* If Auto Cob and DB to disk call SCC2454 */                         /*S01375*/
/* */                                                                 /*S01375*/
             CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('*TODAY    ')  /*S01375*/
             CALL       PGM(CB0602X) PARM(&CB_RTN_CDE &CB_AUTO)       /*S01375*/
/*********** IF         COND((%SST(&CB_AUTO 66 4) *EQ '*YES') *AND +  /*087987*/
/***********                 (%SST(&CB_AUTO 36 5) *EQ '*DISK')) +     /*087987*/
/***********            THEN(DO)                           /*S01375*/ /*087987*/
             IF         COND((%SST(&CB_AUTO 36 5) *EQ '*DISK')) +
                        THEN(DO)                                      /*087987*/
/**/                                                                  /*S01375*/
/*  Call SCC2454 to save the master library                           /*S01375*/
/**/                                                                  /*S01375*/
             CALL       PGM(SCC2454)                                  /*S01375*/
             ENDDO                                                    /*S01375*/
             ELSE       CMD(DO)                                       /*S01375*/
/**/
/*  CALL SCC1712 TO SAVE THE MASTER LIBRARY                           /*S01343*/
/**/
             CALL       PGM(SCC1712) PARM(&BIND &TIND)                /*S01343*/
/**/
/* Call CB0602U to update COB data fields on CBAICDPD */
/**/
             CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('*SETDB    ')  /*S01375*/
             CHGVAR     VAR(%SST(&CB_AUTO 88 5)) VALUE('*TAPE')       /*S01375*/
             CHGVAR     VAR(%SST(&CB_AUTO 93 4)) VALUE(%SST(&CB_AUTO +
                          53 56))                                     /*S01375*/
             CHGVAR     VAR(%SST(&CB_AUTO 107 5)) VALUE('     ')      /*S01375*/
             CALL       PGM(CB0602U) PARM(&CB_RTN_CDE &CB_AUTO)       /*S01375*/
/**/
/* Check &CB_AUTO for submit batch job flag         */
/* and whether termination receivers to disk        */
/**/
             IF         COND((%SST(&CB_AUTO 57 4) *EQ '*YES') *AND +
                             (%SST(&CB_AUTO 83 5) *EQ '*DISK') *AND +
                             (%SST(&CB_AUTO 66 4) *EQ '*YES')) +
                        THEN(DO)                                      /*S01375*/
/************SBMJOB     CMD(CALL PGM(SCC2455)) JOB(MIDAS_SAVE) +
/************             JOBD(SAVEJOBD) RTGDTA(*JOBD)         /*S01375 081177*/
/*/COPY WNCPYSRC,SCC1710013                                          */
/************SBMJOB     CMD(CALL PGM(SCC2455)) JOB(MIDAS_SAVE) +                          /*CPK014*/
/************             JOBD(SAVEJOBD) RTGDTA(*JOBD) +                                  /*CPK014*/
/************             INLLIBL(*JOBD)                              /*081177*/          /*CPK014*/
/************SBMJOB     CMD(CALL PGM(SCC2455)) JOB(MIDAS_SAVE) +                          /*CSC023*/
/************             JOBD(SAVEJOBD) USER(*JOBD) RTGDTA(*JOBD) +                      /*CSC023*/
/************             INLLIBL(*JOBD)                                       /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(SCC2455)) JOB(MIDAS_SAVE) +
                          JOBD(SAVEJOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD) OUTQ(*JOBD)                                      /*CSC023*/
/*/COPY WNCPYSRC,SCC1710014                                          */
             ENDDO                                                    /*S01375*/
/**/                                                                  /*S01375*/
             ENDDO                                                    /*S01375*/
/**/
             GOTO ENDPGM
/**/
/*  ERROR PROCESSING                                                          */
/**/
ABNOR:       SNDPGMMSG  MSG('Beginning of Business Database Save +
                        ENDED ABNORMALLY') TOPGMQ(*EXT)      +
                        TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*           RMVRPYLE   SEQNBR(3)                                   *  *E80902*/
/*           MONMSG     MSGID(CPF0000 RPG0000 MCH0000)              *  *E80902*/
             CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 ENDPGM:     ENDPGM
