/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Set up for journalling')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0405 - Set up for journalling                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD025193           Date 19Aug14              */
/*       Prev Amend No. MD022045           Date 27Aug13              */
/*                      AR762171           Date 26May11              */
/*                      AR1071218          Date 27Jan13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CSC038             Date 18Aug08              */
/*                      260790             Date 19Jun09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG9025            Date 20Oct05              */
/*                      CSC020             Date 31Mar04              */
/*                      CSC018             Date 31May03              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      207764             Date 23Jul02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      192731             Date 11Jul01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             DATE 10MAY95              */
/*                      S01495 *CREATE     DATE 01OCT94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD025193 - Journal sequence number is at the maximum value  */
/*       MD022045 - SCC0404 performance degradation                  */
/*       AR762171 - Meridian Replication jobs fails with MSGW after  */
/*                  COB.  Set start point for Meridian Replication   */
/*                  after COB. (Child: AR762172)                     */
/*       AR1071218 - Data area CSC018 in *LIBL not found             */
/*       CSC038 - Include parameter DTACPR in save commands to reduce*/
/*                run time.                                          */
/*       260790 - COB performance fix                                */
/*                Receivers are saved as they are detached           */
/*       BUG9025 - Error in checking whether receiver sequence       */
/*                 number is reaching its maximum.                   */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CSC018 - Journaling options for High Availability           */
/*       207764 - Change all SAV* and RST* commands to print a       */
/*                report of objects saved or restored.               */
/*       192731 - Change SAVOBJ cmd to have USEOPTBLK *NO            */
/*                instead of *YES                                    */
/*       CCB009 - Journal files throughout close of business         */
/*       S01408 - Addition of core hook SCC0405MP1                   */
/*                Addition of core hook SCC0405MPE                   */
/*       S01495 - COB enhancements.                                  */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&SMSG)   TYPE(*CHAR) LEN(132)
             DCL        VAR(&LIB)    TYPE(*CHAR) LEN(8)  VALUE('  JLIB  ')
             DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MNATN)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&SYSID)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&SUBSYS) TYPE(*CHAR) LEN(6)
             DCL        VAR(&XLIB)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&CPSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
/*/COPY SDCPYSRC,SDSVALDCL                                           */                   /*CSC018*/
             DCL        VAR(&SUPPUPD) TYPE(*CHAR) LEN(20)                                 /*CSC018*/
             DCL        VAR(&DATAQN) TYPE(*CHAR) LEN(10) +
                          VALUE('SCC2470MON')                                             /*260790*/
             DCL        VAR(&DATAQE) TYPE(*CHAR) LEN(10) +
                          VALUE('SCC2470END')                                             /*260790*/
             DCL        VAR(&DATAQL) TYPE(*CHAR) LEN(10)                                  /*260790*/
             DCL        VAR(&DLEN) TYPE(*DEC) LEN(5 0) VALUE(10)                          /*260790*/
             DCL        VAR(&WAIT) TYPE(*DEC) LEN(5 0) VALUE(180)                         /*260790*/
             DCL        VAR(&MESS) TYPE(*CHAR) LEN(10)                                    /*260790*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/*                                                                      CCB009*/
/*  Declare variables required for journal receiver names.              CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&RNUM) TYPE(*DEC) LEN(3 0)                /*CCB009*/
             DCL        VAR(&RNUMA) TYPE(*CHAR) LEN(3)                /*CCB009*/
             DCL        VAR(&LASTRCV) TYPE(*CHAR) LEN(10)             /*CCB009*/
/*                                                                                        /*CSC018*/
/* Declare variables for CSC018 - journaling options for High Availability                /*CSC018*/
/*                                                                                        /*CSC018*/
             DCL        VAR(&CSC018) TYPE(*CHAR) LEN(7)                                   /*CSC018*/
             DCL        VAR(&JNSEQ) TYPE(*DEC) LEN(10 0)                                  /*CSC018*/
             DCL        VAR(&SEQOPT) TYPE(*CHAR) LEN(6)                                   /*CSC018*/
             DCL        VAR(&THRES6) TYPE(*CHAR) LEN(10)                                  /*CSC018*/
             DCL        VAR(&MAXOP6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&RMVIN6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&MINFI6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&CNTSE6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&RMTJR6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&MNGBJ6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&DDMRM6) TYPE(*CHAR) LEN(10)                                  /*CSC018*/
             DCL        VAR(&DDMLI6) TYPE(*CHAR) LEN(10)                                  /*CSC018*/
             DCL        VAR(&IGNTG6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&JLIBRMT) TYPE(*CHAR) LEN(10)                                 /*CSC018*/
             DCL        VAR(&RMTCM6) TYPE(*CHAR) LEN(150)                                 /*CSC018*/
             DCL        VAR(&JLIBBKP) TYPE(*CHAR) LEN(10)                                 /*CSC018*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)                                  /*CSC018*/
             DCL        VAR(&THRESHOLDB) TYPE(*DEC) LEN(15 0)                             /*CSC018*/
             DCL        VAR(&THRESHOLDK) TYPE(*DEC) LEN(15 0)                             /*CSC018*/
             DCL        VAR(&SIZOPT1) TYPE(*CHAR) LEN(10)                                 /*CSC018*/
             DCL        VAR(&SIZOPT2) TYPE(*CHAR) LEN(10)                                 /*CSC018*/
             DCL        VAR(&SIZOPT3) TYPE(*CHAR) LEN(10)                                 /*CSC018*/
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(150)                                    /*CSC018*/
             DCL        VAR(&DTACPRV) TYPE(*CHAR) LEN(10)                                 /*CSC038*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')                  /*AR762171*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                    /*AR762171*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ')                  /*AR762171*/
             DCL        VAR(&CRP006) TYPE(*CHAR) LEN(1) VALUE('N')                      /*AR762171*/
             DCL        VAR(&RPDTASEQ) TYPE(*CHAR) LEN(10)                              /*AR762171*/
             DCL        VAR(&RPBASELIB) TYPE(*CHAR) LEN(10)                             /*AR762171*/
             DCL        VAR(&CURZSEQ) TYPE(*DEC) LEN(10 0)                              /*AR762171*/
             DCL        VAR(&CURZSEQA) TYPE(*CHAR) LEN(10)                              /*AR762171*/
             DCL        VAR(&DTQDLEN) TYPE(*DEC) LEN(5) VALUE(1)                        /*MD022045*/
             DCL        VAR(&T) TYPE(*CHAR) LEN(1) VALUE('T')                           /*MD022045*/
/*/COPY WNCPYSRC,SCC0405007                                          */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/**/                                                                                    /*MD022045*/
/* Terminate report distribution program */                                             /*MD022045*/
/**/                                                                                    /*MD022045*/
             ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(5)                             /*MD022045*/
             MONMSG     MSGID(CPF1002) EXEC(DO)                                         /*MD022045*/
               CALL       PGM(QSNDDTAQ) PARM('FCDTAQ' '*LIBL' +
                            &DTQDLEN &T)                                                /*MD022045*/
DISTLP:                                                                                 /*MD022045*/
               ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(30)                          /*MD022045*/
               MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(DISTLP))                      /*MD022045*/
             ENDDO                                                                      /*MD022045*/
             DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))                                     /*MD022045*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
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
                             'HighAvlContJrnSeqNum' &SVAL5 +
                             'HighAvlRmtJrnActive' &SVAL6 +
                             'HighAvlIgnTgtOnDel' &SVAL7 +
                             'HighAvlMangBackUpJrn' &SVAL8 +
                             'HighAvlDdmFileName' &SVAL9 +
                             'HighAvlDdmFileLib' &SVAL10)                                 /*CSC018*/
                                                                                          /*CSC018*/
/* If there is an error finding any system value then end abnormally */                   /*CSC018*/
                                                                                          /*CSC018*/
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Determine the 2-character system I.D.                                                 /*CSC018*/
/*                                                                                        /*CSC018*/
              RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                              /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Determine whether continuous journal sequence numbers are                             /*CSC018*/
/*  being used.                                                                           /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&CNTSE6) VALUE(%SST(&SVAL5 1 1))                             /*CSC018*/
/*                                                                                       /*BUG9025*/
/*  The following line was moved to here because the value is required.                    BUG9025*/
/*  for testing the journal sequence number.                                               BUG9025*/
/*                                                                                       /*BUG9025*/
/*  Determine whether *MAXOPT1 or *MAXOPT2 are to be used.                               /*BUG9025*/
/*                                                                                       /*BUG9025*/
              CHGVAR     VAR(&MAXOP6) VALUE(%SST(&SVAL1 1 1))                            /*BUG9025*/
/*                                                                                        /*CSC018*/
/*  If continuous journal sequence numbers are being used,                                /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&CNTSE6 *EQ 'Y') THEN(DO)                                   /*CSC018*/
/*                                                                                        /*CSC018*/
/*  set the sequence option to '*CONT' for continuous.                                    /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&SEQOPT) VALUE('*CONT ')                                    /*CSC018*/
/**/                                                                                      /*CSC018*/
/*  Retrieve current journal receiver and sequence number.                                /*CSC018*/
/**/                                                                                      /*CSC018*/
               RTVJRNE    JRN(ICJRN) FROMENT(*LAST) RTNSEQNBR(&JNSEQ)                     /*CSC018*/
/**/                                                                                      /*CSC018*/
/*  If journal size options *MAXOPT1 or *MAXOPT2 are being used,                          /*CSC018*/
/**/                                                                                      /*CSC018*/
               IF         COND((&MAXOP6 *EQ '1') *OR (&MAXOP6 *EQ +
                          '2')) THEN(DO)                                                  /*CSC018*/
/**/                                                                                      /*CSC018*/
/*  If sequence number is greater than 9000000000,                                        /*CSC018*/
/**/                                                                                      /*CSC018*/
/**********     IF         COND(&JNSEQ *GT 9000000000) THEN(DO)      */          /*CSC018 MD025193*/
                IF         COND(&JNSEQ *GT 5000000000) THEN(DO)                         /*MD025193*/
/*                                                                                        /*CSC018*/
/* set the sequence option to '*RESET' to reset the sequence to 1.                        /*CSC018*/
/*                                                                                        /*CSC018*/
                 CHGVAR     VAR(&SEQOPT) VALUE('*RESET')                                  /*CSC018*/
                ENDDO                                                                     /*CSC018*/
               ENDDO                                                                      /*CSC018*/
/**/                                                                                      /*CSC018*/
/*  If journal size options *MAXOPT1 or *MAXOPT2 are NOT being used,                      /*CSC018*/
/**/                                                                                      /*CSC018*/
               ELSE       CMD(DO)
/**/                                                                                      /*CSC018*/
/*  If sequence number is greater than 2000000000,                                        /*CSC018*/
/**/                                                                                      /*CSC018*/
                IF         COND(&JNSEQ *GT 2000000000) THEN(DO)                           /*CSC018*/
/*                                                                                        /*CSC018*/
/* set the sequence option to '*RESET' to reset the sequence to 1.                        /*CSC018*/
/*                                                                                        /*CSC018*/
                 CHGVAR     VAR(&SEQOPT) VALUE('*RESET')                                  /*CSC018*/
                ENDDO                                                                     /*CSC018*/
               ENDDO                                                                      /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If continuous journal sequence numbers are NOT being used,                            /*CSC018*/
/*                                                                                        /*CSC018*/
              ELSE       CMD(DO)
/*                                                                                        /*CSC018*/
/* set the sequence option to '*RESET' to reset the sequence to 1.                        /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&SEQOPT) VALUE('*RESET')                                    /*CSC018*/
              ENDDO
/*                                                                                        /*CSC018*/
/*  Determine whether remote journaling is being used                                     /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&RMTJR6) VALUE(%SST(&SVAL6 1 1))                             /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If remote journaling is used, determine whether to ignore                             /*CSC018*/
/*  target receivers upon deletion.                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&RMTJR6 *EQ 'Y') THEN(DO)                                   /*CSC018*/
               CHGVAR     VAR(&IGNTG6) VALUE(%SST(&SVAL7 1 1))                            /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Calculate the backup machine remote journal library.                                  /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&JLIBRMT) VALUE(&SYSID *CAT 'JLIBRMT ')                     /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Determine whether backup journal management is being used                             /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&MNGBJ6) VALUE(%SST(&SVAL8 1 1))                             /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If backup journal management is being used, calculate the                             /*CSC018*/
/*  name of the backup journal library.                                                   /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&MNGBJ6 *EQ 'Y') THEN(DO)                                   /*CSC018*/
               CHGVAR     VAR(&JLIBBKP) VALUE(&SYSID *CAT 'JLIB    ')                     /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If remote journaling OR backup journal management are being used,                     /*CSC018*/
/*  determine DDM file and library.                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND((&RMTJR6 *EQ 'Y') *OR (&MNGBJ6 *EQ +
                          'Y')) THEN(DO)                                                  /*CSC018*/
               CHGVAR     VAR(&DDMRM6) VALUE(%SST(&SVAL9 1 10))                           /*CSC018*/
               CHGVAR     VAR(&DDMLI6) VALUE(%SST(&SVAL10 1 10))                          /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If any of these fields are blank then remote journaling and                           /*CSC018*/
/*  backup receiver management may not be used.                                           /*CSC018*/
/*                                                                                        /*CSC018*/
               IF         COND((&DDMRM6 *EQ '          ') *OR (&DDMLI6 +
                          *EQ '          ')) THEN(DO)                                     /*CSC018*/
                CHGVAR     VAR(&RMTJR6) VALUE('N')                                        /*CSC018*/
                CHGVAR     VAR(&MNGBJ6) VALUE('N')                                        /*CSC018*/
/*                                                                                     /*AR1071218*/
/*  Check if CSC018 exists in QTEMP                                                    /*AR1071218*/
/*                                                                                     /*AR1071218*/
                CHKOBJ     OBJ(CSC018) OBJTYPE(*DTAARA)                                /*AR1071218*/
                MONMSG     MSGID(CPF9801) EXEC(DO)                                     /*AR1071218*/
                CRTDTAARA  DTAARA(QTEMP/CSC018) TYPE(*CHAR) LEN(256)                   /*AR1071218*/
                ENDDO                                                                  /*AR1071218*/
                                                                                       /*AR1071218*/
                CHGDTAARA  DTAARA(CSC018 (15 2)) VALUE('  ')                              /*CSC018*/
               ENDDO                                                                      /*CSC018*/
              ENDDO                                                                       /*CSC018*/
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
/*                                                                                         BUG9025*/
/*  The following line was moved up and has already been executed at this stage.           BUG9025*/
/*                                                                                         BUG9025*/
/**********                                                                       *CSC018**BUG9025*/
/***Determine whether *MAXOPT1 or *MAXOPT2 are to be used.                        *CSC018**BUG9025*/
/**********                                                                       *CSC018**BUG9025*/
/**********   CHGVAR     VAR(&MAXOP6) VALUE(%SST(&SVAL1 1 1))                     *CSC018**BUG9025*/
/*                                                                                        /*CSC018*/
/*  Determine whether internal journal entries are to be removed.                         /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&RMVIN6) VALUE(%SST(&SVAL3 1 1))                             /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If value is blank on the system value.                                                /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&RMVIN6 *EQ ' ') THEN(DO)                                   /*CSC018*/
/*                                                                                        /*CSC018*/
/*  set a default value of 'N',                                                           /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&RMVIN6) VALUE('N')                                         /*CSC018*/
               CHGVAR     VAR(%SST(&SVAL3 1 1)) VALUE('N')                                /*CSC018*/
/*                                                                                     /*AR1071218*/
/*  Check if CSC018 exists in QTEMP                                                    /*AR1071218*/
/*                                                                                     /*AR1071218*/
                CHKOBJ     OBJ(CSC018) OBJTYPE(*DTAARA)                                /*AR1071218*/
                MONMSG     MSGID(CPF9801) EXEC(DO)                                     /*AR1071218*/
                CRTDTAARA  DTAARA(QTEMP/CSC018) TYPE(*CHAR) LEN(256)                   /*AR1071218*/
                ENDDO                                                                  /*AR1071218*/
/*                                                                                        /*CSC018*/
/*  and update the system value                                                           /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGDTAARA  DTAARA(CSC018 (12 1)) VALUE('N')                                /*CSC018*/
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
/**/
/* Stop the SCC2470MON journal save process */                                            /*260790*/
/**/                                                                                      /*260790*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                               /*260790*/
             CHGVAR     VAR(&DATAQL) VALUE(&SYSID *CAT 'XLIB')                            /*260790*/
             CHGVAR     VAR(&MESS) VALUE('STOP      ')
             CALL       PGM(QSNDDTAQ) PARM(&DATAQN &DATAQL &DLEN &MESS)                   /*260790*/
/**/                                                                                      /*260790*/
/* Wait for the response */                                                               /*260790*/
/**/                                                                                      /*260790*/
             CALL       PGM(QRCVDTAQ) PARM(&DATAQE &DATAQL &DLEN &MESS +
                          &WAIT)                                                          /*260790*/
                                                                                          /*260790*/
/**/
/*  Check that the required data areas exist                       */
/**/
/*  JNSTAT                                                         */
/**/
             CHKOBJ     OBJ(JNSTAT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                        - data area JNSTAT not found ')
             SNDMSG     MSG(&SMSG) TOMSGQ(MOPERQ)
             CHGJOB     SWS(XXXXXX11)
             GOTO       CMDLBL(ENDPGM)
/**/
             ENDDO
/**/
/*  MNATN                                                          */
/**/
             CHKOBJ     OBJ(MNATN) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                        - data area MNATN not found ')
             SNDMSG     MSG(&SMSG) TOMSGQ(MOPERQ)
             CHGJOB     SWS(XXXXXX11)
             GOTO       CMDLBL(ENDPGM)
/**/
             ENDDO
/**/
/*  SDSTAT                                                         */
/**/
             CHKOBJ     OBJ(SDSTAT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                        - data area SDSTAT not found ')
             SNDMSG     MSG(&SMSG) TOMSGQ(MOPERQ)
             CHGJOB     SWS(XXXXXX11)
             GOTO       CMDLBL(ENDPGM)
/**/
             ENDDO
/**/
/*  NOTE : If a call or internal code change which produces a      */
/*         report is added to this program, it is VITAL that the   */
/*         new call/code is run before the call to FCC01. Failure  */
/*         to do so will result in CoB failure.                    */
/**/
             CALL       PGM(FCC01)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
/*/COPY WNCPYSRC,SCC0405008                                          */
/**/
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)
/**/
/*  Change dual receivers at B.O.B. to that value last selected    */
/*  by the user during input cycle or at systen setup, then        */
/*  initialise all system defined areas of JNSTAT                  */
/**/
/*  ARCV       ATTACHED RECEIVER                                   */
/**/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             CHGVAR     VAR(%SST(&JNSTAT 1 8)) VALUE('ICRCV000')
/**/
/*  NRCV       NEXT RECEIVER TO BE SAVED                           */
/**/
             CHGVAR     VAR(%SST(&JNSTAT 11 8))  VALUE('ICRCV000')
             ENDDO                                                    /*CCB009*/
/**/
/*  VNIC       VOL ID OF NEXT I/C DATABASE TO BE SAVED             */
/**/
/*/COPY WNCPYSRC,SCC0405001                                          */
             CHGVAR     VAR(%SST(&JNSTAT 63 5)) VALUE('DB001')
/*/COPY WNCPYSRC,SCC0405002                                          */
/**/
/*  DRBB       DUAL RECEIVERS AT B OF B                            */
/**/
             CHGVAR     VAR(%SST(&JNSTAT 68 1)) +
                          VALUE(%SST(&JNSTAT 70 1))
/**/
/*  RCVP       RECEIVER SAVE IN PROGRESS                           */
/**/
             CHGVAR     VAR(%SST(&JNSTAT 69 1)) VALUE('N')
/**/
/*  SUCC       SUCCESSFUL RECOVERY RUN TODAY                       */
/**/
             CHGVAR     VAR(%SST(&JNSTAT 74 1)) VALUE('N')
/**/
/*  VLIC       VOL ID OF LAST I/C DATABASE SAVE                    */
/**/
/*/COPY WNCPYSRC,SCC0405003                                          */
             CHGVAR     VAR(%SST(&JNSTAT 75 5)) VALUE('DB001')
/*/COPY WNCPYSRC,SCC0405004                                          */
/**/
/*  RDBV       RESTORE OF DISK BACKUP VALID                        */
/**/
             CHGVAR     VAR(%SST(&JNSTAT 81 1)) VALUE('N')
/**/
/*  RCVR       LAST RECEIVER RESTORED                              */
/**/
             CHGVAR     VAR(%SST(&JNSTAT 83 8)) VALUE('ICRCV000')
/**/
/*  RCVA       LAST RECEIVER APPLIED                               */
/**/
             CHGVAR     VAR(%SST(&JNSTAT 93 8)) VALUE('ICRCV000')
/**/
/*  Update data area JNSTAT                                        */
/**/
             CHGDTAARA  DTAARA(JNSTAT) VALUE(&JNSTAT)
/**/
             RTVDTAARA  DTAARA(CPSTAT) RTNVAR(&CPSTAT)
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             IF         COND((%SST(&MMOD 45 1) = 'Y') *AND +
                          (%SST(&CPSTAT 11 2) = 'YY'))     +
                          THEN(CALL PGM(CPC01))
/***********************************************************************CCB009**************CSC020*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),********CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************IF*********COND(&CCB009**NE*'*******')*THEN(DO)************CCB009**************CSC020*/
/*******************************************************************************************CSC020*/
/***End*journalling*PF*to*enable*deletion***************************************************CSC020*/
/*******************************************************************************************CSC020*/
/*/COPY WNCPYSRC,SCC0405009                                          */
/************ENDJRNPF***FILE(*ALL)*JRN(ICJRN)***********************************************CSC020*/
/************MONMSG*****MSGID(CPF0000*MCH0000)**********************************************CSC020*/
/*******************************************************************************************CSC020*/
/***Delete*journal*&*journal*receivers******************************************************CSC020*/
/*******************************************************************************************CSC020*/
/************DLTJRN*****JRN(ICJRN)**********************************************************CSC020*/
/*******************************************************************************************CSC020*/
/***If*journal*not*found,*processing*continues.*If*any*other*error**************************CSC020*/
/***occurs,*journal*is*not*deleted,*error*msg*is*sent***************************************CSC020*/
/***&*program*ends**************************************************************************CSC020*/
/*******************************************************************************************CSC020*/
/************MONMSG*****MSGID(CPF2105)*EXEC(GOTO*CMDLBL(LOW1))******************************CSC020*/
/************MONMSG*****MSGID(CPF0000)*EXEC(DO)*********************************************CSC020*/
/************CHGVAR*****VAR(&SMSG)*VALUE('Job*terminated*+**********************************CSC020*/
/***********************-*Journal*cannot*be*deleted')***************************************CSC020*/
/************SNDMSG*****MSG(&SMSG)*TOMSGQ(MOPERQ)*******************************************CSC020*/
/************CHGJOB*****SWS(XXXXXX11)*******************************************************CSC020*/
/************GOTO*******CMDLBL(ENDPGM)******************************************************CSC020*/
/*******************************************************************************************CSC020*/
/************ENDDO**************************************************************************CSC020*/
/*/COPY WNCPYSRC,SCC0405010                                          */
/*******************************************************************************************CSC020*/
/***Change*job*attributes*for*INQMSGRPY*so*that*"Receiver*never*had*************************CSC020*/
/***full*save"*messages*are*answered*automatically*by*the*program,**************************CSC020*/
/***then*change*the*job*again*to*the*original*state*after*receivers*************************CSC020*/
/***have*been*deleted***********************************************************************CSC020*/
/*******************************************************************************************CSC020*/
/*LOW1:******CHGJOB*****INQMSGRPY(*DFT)*****************************************************CSC020*/
/*******************************************************************************************CSC020*/
/***If*receivers*not*found,*processing*continues.*If*any*other******************************CSC020*/
/***error*occurs,*receivers*not*deleted,*error*msg*is*sent*&********************************CSC020*/
/***program*ends****************************************************************************CSC020*/
/*******************************************************************************************CSC020*/
/*/COPY WNCPYSRC,SCC0405011                                          */
/************DLTJRNRCV**JRNRCV(ICRCV*)******************************************************CSC020*/
/************MONMSG*****MSGID(CPF2105*CPF2125)*EXEC(GOTO*CMDLBL(ALC1))**********************CSC020*/
/************MONMSG*****MSGID(CPF0000)*EXEC(DO)*********************************************CSC020*/
/************CHGVAR*****VAR(&SMSG)*VALUE('Job*terminated*+**********************************CSC020*/
/***********************-*Receivers*cannot*be*deleted')*************************************CSC020*/
/************SNDMSG*****MSG(&SMSG)*TOMSGQ(MOPERQ)*******************************************CSC020*/
/************CHGJOB*****INQMSGRPY(*RQD)*SWS(XXXXXX11)***************************************CSC020*/
/************GOTO*******CMDLBL(ENDPGM)******************************************************CSC020*/
/*******************************************************************************************CSC020*/
/************ENDDO**************************************************************************CSC020*/
/*/COPY WNCPYSRC,SCC0405012                                          */
/*******************************************************************************************CSC020*/
/*ALC1:******CHGJOB*****INQMSGRPY(*RQD)*****************************************************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/************ELSE*******CMD(DO)*****************************************CCB009**************CSC020*/
/*                                                                      CCB009*/
/*  Call new program SCC2461 to save close of business                  CCB009*/
/*  receivers to save files.                                            CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(SCC2461)                                  /*CCB009*/
/***********************************************************************CCB009**************CSC020*/
/***Delete*receiver*ICRCV001.*******************************************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************CHGJOB*****INQMSGRPY(*DFT)*********************************CCB009**************CSC020*/
/*********************************************************************************CSC018****CSC020*/
/**If*Feature*CSC018*is*'on',*and*if*Remote*Journaling*is*being*used**************CSC018****CSC020*/
/**and*if*'Ignore*Target*Receiver'*is*'Y',****************************************CSC018****CSC020*/
/**then*delete*receiver*with*option**IGNTGTRCV************************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/************IF*********COND((&CSC018**EQ*'*******')**AND*(&RMTJR6*+************************CSC020*/
/**************************EQ*'Y')**AND*(&IGNTG6**EQ*'Y'))*+********************************CSC020*/
/*************************THEN(DO)************************************************CSC018****CSC020*/
/************DLTJRNRCV**JRNRCV(ICRCV001)*DLTOPT(*IGNTGTRCV)***********************CSC018****CSC020*/
/************MONMSG*****MSGID(CPF0000)********************************************CSC018****CSC020*/
/************ENDDO****************************************************************CSC018****CSC020*/
/************ELSE*******CMD(DO)***************************************************CSC018****CSC020*/
/************DLTJRNRCV**JRNRCV(ICRCV001)********************************CCB009****CSC020****CSC020*/
/************MONMSG*****MSGID(CPF0000)**********************************CCB009****CSC020****CSC020*/
/************ENDDO****************************************************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/**If*remote*journaling*is*being*used,********************************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/************IF*********COND(&RMTJR6**EQ*'Y')*THEN(DO)****************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/**Calculate*remote*command*to*delete*receiver*ICRCV001.**************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/************CHGVAR*****VAR(&RMTCM6)*VALUE('*')***********************************CSC018****CSC020*/
/************CHGVAR*****VAR(&RMTCM6)*VALUE('DLTJRNRCV*'**CAT*+******************************CSC020*/
/*************************&JLIBRMT**TCAT*'/ICRCV001'**CAT*'*+*******************************CSC020*/
/*************************DLTOPT(*IGNINQMSG)')************************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/**Execute*the*remote*command*to*delete*receiver*ICRCV001*in*the*remote***********CSC018****CSC020*/
/**journaling*library*on*the*other*machine.***************************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/************SBMRMTCMD**CMD(&RMTCM6)*DDMFILE(&DDMLI6/&DDMRM6)*********************CSC018****CSC020*/
/************MONMSG*****MSGID(CPF0000*MCH0000)************************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/************ENDDO****************************************************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/**If*Backup*journal*Management*is*being*used,************************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/************IF*********COND(&MNGBJ6**EQ*'Y')*THEN(DO)****************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/**Calculate*remote*command*to*delete*receiver*ICRCV001.**************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/************CHGVAR*****VAR(&RMTCM6)*VALUE('*')***********************************CSC018****CSC020*/
/************CHGVAR*****VAR(&RMTCM6)*VALUE('DLTJRNRCV*'**CAT*+******************************CSC020*/
/*************************&JLIBBKP**TCAT*'/ICRCV001'**CAT*'*+*******************************CSC020*/
/*************************DLTOPT(*IGNINQMSG)')************************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/**Execute*the*remote*command*to*delete*receiver*ICRCV001*in*the******************CSC018****CSC020*/
/**journaling*library*on*the*backup*machine.**************************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/************SBMRMTCMD**CMD(&RMTCM6)*DDMFILE(&DDMLI6/&DDMRM6)*********************CSC018****CSC020*/
/************MONMSG*****MSGID(CPF0000*MCH0000)************************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/************ENDDO****************************************************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/************RTVDTAARA**DTAARA(JNSTAT)*RTNVAR(&JNSTAT)******************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/***If*dual*receivers*are*being*used,*delete*ICRCV002.******************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************IF*********COND(%SUBSTRING(&JNSTAT*70*1)**EQ*'Y')*+****************************CSC020*/
/*************************THEN(DO)**************************************CCB009**************CSC020*/
/************DLTJRNRCV**JRNRCV(ICRCV002)********************************CCB009**************CSC020*/
/************MONMSG*****MSGID(CPF0000)**********************************CCB009**************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/************CHGJOB*****INQMSGRPY(*RQD)*********************************CCB009**************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/**/
/*  Obtain library ID from SDSTAT                                  */
/**/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(%SUBSTRING(&LIB 1 2)) +
                          VALUE(%SUBSTRING(&SDSTAT 6 2))
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC0405MP1                                          */
                                                                      /*S01408*/
/**/
/*  Create the new journal & receiver(s) -                         */
/***(A)*If*dual*receivers*are*to*be*used****************************************************CSC020*/
/*******************************************************************************************CSC020*/
/************RTVDTAARA**DTAARA(JNSTAT)*RTNVAR(&JNSTAT)**************************************CSC020*/
/************IF*********COND(%SUBSTRING(&JNSTAT*70*1)**EQ*'Y')*THEN(DO)*********************CSC020*/
/*******************************************************************************************CSC020*/
/*/COPY WNCPYSRC,SCC0405013                                          */
/***********************************************************************CCB009**************CSC020*/
/**If*Feature*CCB009*is*'on'*(close*of*business*journaling),************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************IF*********COND(&CCB009**EQ*'*******')*THEN(DO)************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/***Create*new*receivers*ICRCV001*and*ICRCV002*with*high*threshold.*****CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************CRTJRNRCV**JRNRCV(&LIB/ICRCV001)*ASP(%SST(&JNSTAT*151*+************************CSC020*/
/*************************2))*THRESHOLD(1900000)*TEXT('receiver*for*+***********************CSC020*/
/*************************journal*icjrn')*******************************CCB009**************CSC020*/
/************MONMSG*****MSGID(CPF0000*MCH0000)**************************CCB009**************CSC020*/
/************CRTJRNRCV**JRNRCV(&LIB/ICRCV002)*ASP(%SST(&JNSTAT*151*+************************CSC020*/
/*************************2))*THRESHOLD(1900000)*TEXT('receiver*for*+***********************CSC020*/
/*************************journal*icjrn')*******************************CCB009**************CSC020*/
/************MONMSG*****MSGID(CPF0000*MCH0000)**************************CCB009**************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/************ELSE*******CMD(DO)*****************************************CCB009**************CSC020*/
/************CRTJRNRCV**JRNRCV(&LIB/ICRCV001)*ASP(%SST(&JNSTAT*151*+************************CSC020*/
/*************************2))*TEXT('receiver*for*journal*icjrn')****************************CSC020*/
/************CRTJRNRCV**JRNRCV(&LIB/ICRCV002)*ASP(%SST(&JNSTAT*151*+************************CSC020*/
/*************************2))*TEXT('receiver*for*journal*icjrn')****************************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),********CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************IF*********COND(&CCB009**NE*'*******')*THEN(DO)************CCB009**************CSC020*/
/************CRTJRN*****JRN(&LIB/ICJRN)*JRNRCV(ICRCV001*ICRCV002)*+*************************CSC020*/
/*************************ASP(%SST(&JNSTAT*149*2))******************************************CSC020*/
/************MONMSG*****MSGID(CPF0000*RPG0000*MCH0000)******************CCB009**************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/*/COPY WNCPYSRC,SCC0405014                                          */
/************CHGDTAARA**DTAARA(JNSTAT*(68*1))*VALUE('Y')************************************CSC020*/
/*******************************************************************************************CSC020*/
/************ENDDO**************************************************************************CSC020*/
/*******************************************************************************************CSC020*/
/***(B)*If*single*receivers*are*to*be*used**************************************************CSC020*/
/*******************************************************************************************CSC020*/
/************ELSE*******CMD(DO)*************************************************************CSC020*/
/*******************************************************************************************CSC020*/
/*/COPY WNCPYSRC,SCC0405015                                          */
/***********************************************************************CCB009**************CSC020*/
/**If*Feature*CCB009*is*'on'*(close*of*business*journaling),************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************IF*********COND(&CCB009**EQ*'*******')*THEN(DO)************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/***Create*new*receiver*ICRCV001*with*high*threshold.*******************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************IF*********COND(&CSC018**NE*'*******')*THEN(DO)**********************CSC018****CSC020*/
/************CRTJRNRCV**JRNRCV(&LIB/ICRCV001)*ASP(%SST(&JNSTAT*151*+************************CSC020*/
/*************************2))*THRESHOLD(1900000)*TEXT('receiver*for*+***********************CSC020*/
/*************************journal*ICJRN')*******************************CCB009**************CSC020*/
/************MONMSG*****MSGID(CPF0000*MCH0000)**************************CCB009**************CSC020*/
/*******************************************************************************************CSC020*/
/************ENDDO****************************************************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/**If*feature*CSC018,*High*Availability*Options,*is*present,**********************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/************ELSE*******CMD(DO)***************************************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/**Create*journal*receiver*with*required*threshold.*******************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/************CRTJRNRCV**JRNRCV(&LIB/ICRCV001)*ASP(%SST(&JNSTAT*151*+************************CSC020*/
/*************************2))*THRESHOLD(&THRES6)*TEXT('receiver*+***************************CSC020*/
/*************************for*journal*ICJRN')*************************************CSC018****CSC020*/
/************MONMSG*****MSGID(CPF0000*MCH0000)************************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/**If*Backup*Journal*Management*is*being*used,************************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/************IF*********COND(&MNGBJ6**EQ*'Y')*THEN(DO)****************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/**Calculate*remote*command*to*create*receiver*ICRCV001.**************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/************CHGVAR*****VAR(&RMTCM6)*VALUE('*')************************************CSC018***CSC020*/
/************CHGVAR*****VAR(&RMTCM6)*VALUE('CRTJRNRCV*JRNRCV('**CAT*+***********************CSC020*/
/*************************&JLIBBKP**TCAT*'/ICRCV001)*ASP('**CAT*+***************************CSC020*/
/*************************%SST(&JNSTAT*151*2)**CAT*')*THRESHOLD('*+*************************CSC020*/
/**************************CAT*&THRES6**CAT*')*TEXT(''Receiver*+****************************CSC020*/
/*************************for*journal*ICJRN'')')**********************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/**Execute*the*remote*command*to*create*receiver*ICRCV001*in*the******************CSC018****CSC020*/
/**journaling*library*on*the*backup*machine.**************************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/************SBMRMTCMD**CMD(&RMTCM6)*DDMFILE(&DDMLI6/&DDMRM6)*********************CSC018****CSC020*/
/************MONMSG*****MSGID(CPF0000*MCH0000)************************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/************ENDDO****************************************************************CSC018****CSC020*/
/*********************************************************************************CSC018****CSC020*/
/************ENDDO****************************************************************CSC018****CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/************ELSE*******CMD(DO)*****************************************CCB009**************CSC020*/
/************CRTJRNRCV**JRNRCV(&LIB/ICRCV001)*ASP(%SST(&JNSTAT*151*+************************CSC020*/
/*************************2))*TEXT('receiver*for*journal*icjrn')*+**************************CSC020*/
/***************************S01173**********************************************************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),********CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************IF*********COND(&CCB009**NE*'*******')*THEN(DO)************CCB009**************CSC020*/
/************CRTJRN*****JRN(&LIB/ICJRN)*JRNRCV(ICRCV001)*+**********************************CSC020*/
/*************************ASP(%SST(&JNSTAT*149*2))***S01173*********************************CSC020*/
/************MONMSG*****MSGID(CPF0000*RPG0000*MCH0000)******************CCB009**************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/*/COPY WNCPYSRC,SCC0405016                                          */
/************CHGDTAARA**DTAARA(JNSTAT*(68*1))*VALUE('N')************************************CSC020*/
/*******************************************************************************************CSC020*/
/************ENDDO**************************************************************************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/**If*Feature*CCB009*is*'on'*(close*of*business*journaling),************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************IF*********COND(&CCB009**EQ*'*******')*THEN(DO)************CCB009**************CSC020*/
/*                                                                      CCB009*/
/**Change*the*journal*receiver*to*ICRCV001*for*the*new*day.*************CCB009**************CSC020*/
/* Change the journal receiver for the new day.                                             CSC020*/
/***********************************************************************CCB009**************CSC020*/
/**If*Feature*CSC018*(journaling*options*for*high*availability),*******************CSC018***CSC020*/
/***is*NOT*on,*********************************************************************CSC018***CSC020*/
/**********************************************************************************CSC018***CSC020*/
/************IF*********COND(&CSC018**NE*'*******')*THEN(DO)***********************CSC018***CSC020*/
/************CHGJRN*****JRN(ICJRN)*JRNRCV(ICRCV001)*SEQOPT(*RESET)*+************************CSC020*/
/*************************MNGRCV(*USER)*********************************CCB009**************CSC020*/
/************MONMSG*****MSGID(CPF0000*MCH0000)**************************CCB009**************CSC020*/
/*******************************************************************************************CSC020*/
/************ENDDO*****************************************************************CSC018***CSC020*/
/**********************************************************************************CSC018***CSC020*/
/**If*feature*CSC018,*High*Availability*Options,*is*present,***********************CSC018***CSC020*/
/**********************************************************************************CSC018***CSC020*/
/************ELSE*******CMD(DO)****************************************************CSC018***CSC020*/
              CHGVAR     VAR(&CMD) VALUE(' ')                                             /*CSC018*/
/*************CHGVAR*****VAR(&CMD)*VALUE('CHGJRN*JRN(ICJRN)*+*******************************CSC020*/
/*************************JRNRCV(ICRCV001)*SEQOPT('**CAT*&SEQOPT*+**************************CSC020*/
/*************************JRNRCV(*GEN)*SEQOPT('**CAT*&SEQOPT*+******************************CSC020*/
/**************************TCAT*')*MNGRCV(*USER)*RCVSIZOPT('**CAT*+*************************CSC020*/
/*************************&SIZOPT1**BCAT*&SIZOPT2**BCAT*&SIZOPT3*+**************************CSC020*/
/**************************TCAT*')')**********************************************CSC018****CSC020*/
              CHGVAR     VAR(&CMD) VALUE('CHGJRN JRN(ICJRN) +
                          JRNRCV(*GEN) SEQOPT(' *CAT &SEQOPT +
                          *TCAT ') MNGRCV(*USER) RCVSIZOPT(' *CAT +
                          &SIZOPT1 *BCAT &SIZOPT2 *BCAT &SIZOPT3 +
                          *TCAT ')')                                                      /*CSC020*/
              CALL       PGM(QCMDEXC) PARM(&CMD 150)                                      /*CSC018*/
              MONMSG     MSGID(CPF0000 MCH0000)                                           /*CSC018*/
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             SCWRTJREG  EVENT(NDSUJR) COMP(SCC0405) CMPSEQ(00001) +
                          TEXT('Journal receiver changed at next +
                          day set up')                                                    /*CSC020*/
/*                                                                                        /*CSC018*/
/* If Backup Journal Management is being used,                                            /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND(&MNGBJ6 *EQ 'Y') THEN(DO)                                    /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate remote command to execute CHGJRN command.                                    /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&RMTCM6) VALUE(' ')                                           /*CSC018*/
/************CHGVAR*****VAR(&RMTCM6)*VALUE('CHGJRN*JRN('**CAT*+*****************************CSC020*/
/*************************&JLIBBKP**TCAT*'/ICJRN)*JRNRCV('**CAT*+***************************CSC020*/
/*************************&JLIBBKP**TCAT*'/ICRCV001)*SEQOPT('**CAT*+************************CSC020*/
/*************************&SEQOPT**TCAT*')*MNGRCV(*USER)*+**********************************CSC020*/
/*************************RCVSIZOPT('**CAT*&SIZOPT1**BCAT*&SIZOPT2*+************************CSC020*/
/**************************BCAT*&SIZOPT3**TCAT*')')*********************************CSC018**CSC020*/
             CHGVAR     VAR(&RMTCM6) VALUE('CHGJRN JRN(' *CAT +
                          &JLIBBKP *TCAT '/ICJRN) JRNRCV(*GEN) +
                          SEQOPT(' *CAT &SEQOPT *TCAT ') +
                          MNGRCV(*USER) RCVSIZOPT(' *CAT &SIZOPT1 +
                          *BCAT &SIZOPT2 *BCAT &SIZOPT3 *TCAT ')')                        /*CSC020*/
/*                                                                                        /*CSC018*/
/* Execute the remote command to execute the CHGJRN command on the                        /*CSC018*/
/* backup machine.                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
             SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)                             /*CSC018*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CSC018*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
/************ENDDO*****************************************************************CSC018***CSC020*/
/*                                                                                        /*CSC018*/
/**/                                                                                    /*AR762171*/
/*  Check if the REPLICATION Feature is on. */                                          /*AR762171*/
/**/                                                                                    /*AR762171*/
             CHGVAR     VAR(&SAR) VALUE('CRP006')                                       /*AR762171*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                     /*AR762171*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &AOFMT)                     /*AR762171*/
/**/                                                                                    /*AR762171*/
/*  If the Replication feature is ON, */                                                /*AR762171*/
/**/                                                                                    /*AR762171*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                              /*AR762171*/
/**/                                                                                    /*AR762171*/
/*  set the feature flag to 'Y'. */                                                     /*AR762171*/
/**/                                                                                    /*AR762171*/
             CHGVAR     VAR(&CRP006) VALUE('Y')                                         /*AR762171*/
/**/                                                                                    /*AR762171*/
             ENDDO                                                                      /*AR762171*/
/**/                                                                                    /*AR762171*/
/*  If the Replication feature is OFF, */                                               /*AR762171*/
/**/                                                                                    /*AR762171*/
             ELSE       CMD(DO)                                                         /*AR762171*/
/**/                                                                                    /*AR762171*/
/*  Check whether the Replication library data area exists anyway. */                   /*AR762171*/
/**/                                                                                    /*AR762171*/
             CHKOBJ     OBJ(RPLIBNAMES) OBJTYPE(*DTAARA)                                /*AR762171*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                         /*AR762171*/
             CHGVAR     VAR(&CRP006) VALUE('N')                                         /*AR762171*/
             GOTO       CMDLBL(eSKIPPER)                                                /*AR762171*/
             ENDDO                                                                      /*AR762171*/
/**/                                                                                    /*AR762171*/
/*  If the Replication libraries data area exists, */                                   /*AR762171*/
/*  set the feature flag to 'Y'. */                                                     /*AR762171*/
/**/                                                                                    /*AR762171*/
             CHGVAR     VAR(&CRP006) VALUE('Y')                                         /*AR762171*/
/**/                                                                                    /*AR762171*/
             ENDDO                                                                      /*AR762171*/
eSKIPPER:                                                                               /*AR762171*/
/**/                                                                                    /*AR762171*/
/*  If the Replication flag is 'Y', */                                                  /*AR762171*/
/**/                                                                                    /*AR762171*/
             IF         COND(&CRP006 *EQ 'Y') THEN(DO)                                  /*AR762171*/
/**/                                                                                    /*AR762171*/
/* retrieve the name of the Replication base library. */                                /*AR762171*/
/**/                                                                                    /*AR762171*/
                RTVDTAARA  DTAARA(RPLIBNAMES (11 10)) RTNVAR(&RPBASELIB)                /*AR762171*/
                MONMSG     MSGID(CPF0000)                                               /*AR762171*/
/**/                                                                                    /*AR762171*/
/* Calculate the name of the journal sequence number data area. */                      /*AR762171*/
/* The name can vary, depending on the version of Replication */                        /*AR762171*/
/* installed. */                                                                        /*AR762171*/
/**/                                                                                    /*AR762171*/
                CHGVAR     VAR(&RPDTASEQ) VALUE('JD' *CAT &SYSID *CAT +
                          '1SEQ1 ')                                                     /*AR762171*/
                CHKOBJ     OBJ(&RPBASELIB/&RPDTASEQ) OBJTYPE(*DTAARA)                   /*AR762171*/
                MONMSG     MSGID(CPF9801) EXEC(DO)                                      /*AR762171*/
                CHGVAR     VAR(&RPDTASEQ) VALUE('JDFDR' *CAT &SYSID *CAT +
                          '11 ')                                                        /*AR762171*/
                ENDDO                                                                   /*AR762171*/
/**/                                                                                    /*AR762171*/
/* Retrieve the current journal sequence number. */                                     /*AR762171*/
/**/                                                                                    /*AR762171*/
             RTVJRNE    JRN(ICJRN) FROMENTLRG(*LAST) +
                          RTNSEQNBR(&CURZSEQ)                                           /*AR762171*/
             CHGVAR     VAR(&CURZSEQA) VALUE(&CURZSEQ)                                  /*AR762171*/
/**/                                                                                    /*AR762171*/
/* Update the data area with the journal sequence number. */                            /*AR762171*/
/**/                                                                                    /*AR762171*/
                CHGDTAARA  DTAARA(&RPBASELIB/&RPDTASEQ (1 10)) +
                             VALUE(&CURZSEQA)                                           /*AR762171*/
                MONMSG     MSGID(CPF0000 MCH0000)                                       /*AR762171*/
/**/                                                                                    /*AR762171*/
             ENDDO                                                                      /*AR762171*/
/*                                                                      CCB009*/
/* Save the final receiver from the previous day.                       CCB009*/
/*                                                                      CCB009*/
             RTVDTAARA  DTAARA(JNSTAT (1 10)) RTNVAR(&LASTRCV)        /*CCB009*/
/**********  SAVOBJ     OBJ(&LASTRCV) LIB(&LIB) DEV(*SAVF) +
/**********               OBJTYPE(*JRNRCV) SAVF(&LASTRCV) CLEAR(*ALL) /*CCB009  193721*/
/**********  SAVOBJ     OBJ(&LASTRCV) LIB(&LIB) DEV(*SAVF) +          */       /*193721*/ /*207764*/
/**********             OBJTYPE(*JRNRCV) SAVF(&LASTRCV) CLEAR(*ALL) + */       /*193721*/ /*207764*/
/**********             USEOPTBLK(*NO)                                */       /*193721*/ /*207764*/
/*  Get the Value for Data Compression parameter in save commands                         /*CSC038*/
                                                                                          /*CSC038*/
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                             'SavDataCompression' &SVAL1 +
                             ' ' &SVAL2 +
                             ' ' &SVAL3 +
                             ' ' &SVAL4 +
                             ' ' &SVAL5 +
                             ' ' &SVAL6 +
                             ' ' &SVAL7 +
                             ' ' &SVAL8 +
                             ' ' &SVAL9 +
                             ' ' &SVAL10)                                                 /*CSC038*/
                                                                                          /*CSC038*/
/* If there is an error finding any system value then end abnormally */                   /*CSC038*/
                                                                                          /*CSC038*/
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*CSC038*/
             CHGVAR     VAR(&DTACPRV) VALUE(&SVAL1)                                       /*CSC038*/
                                                                                          /*CSC038*/
             SAVOBJ     OBJ(&LASTRCV) LIB(&LIB) DEV(*SAVF) +
                        OBJTYPE(*JRNRCV) SAVF(&LASTRCV) CLEAR(*ALL) +
                        USEOPTBLK(*NO) OUTPUT(*PRINT) DTACPR(&DTACPRV)                    /*CSC038*/
/*                      USEOPTBLK(*NO) OUTPUT(*PRINT)              */              /*207764 CSC038*/
/************ENDDO******************************************************CCB009**************CSC020*/
/**/
/*  Initialise MNATN & JNSTAT data areas                           */
/**/
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)
             RTVDTAARA  DTAARA(MNATN) RTNVAR(&MNATN)
/**/
             CHGVAR     VAR(&MNATN) VALUE('00001')
/**/
             RTVJRNE    JRN(ICJRN) FROMENT(*LAST) RTNRCV(&LASTRCV)                        /*CSC020*/
/************CHGVAR*****VAR(%SUBSTRING(&JNSTAT*1*20))*+*************************************CSC020*/
/*************************VALUE('ICRCV001**ICRCV001**')*************************************CSC020*/
             CHGVAR     VAR(%SUBSTRING(&JNSTAT 1 10)) +
                          VALUE(&LASTRCV)                                                 /*CSC020*/
             CHGVAR     VAR(%SUBSTRING(&JNSTAT 11 10)) +
                          VALUE(&LASTRCV)                                                 /*CSC020*/
/*/COPY WNCPYSRC,SCC0405005                                          */
             CHGVAR     VAR(%SUBSTRING(&JNSTAT 63 5)) +
                          VALUE('DB001')
/*/COPY WNCPYSRC,SCC0405006                                          */
             CHGVAR     VAR(%SUBSTRING(&JNSTAT 74 1)) +
                          VALUE('N')
             CHGVAR     VAR(%SUBSTRING(&JNSTAT 75 5)) +
                          VALUE('     ')
             CHGVAR     VAR(%SUBSTRING(&JNSTAT 81 1)) +
                          VALUE('N')
/**/
             CHGDTAARA  DTAARA(JNSTAT) VALUE(&JNSTAT)
             CHGDTAARA  DTAARA(MNATN) VALUE(&MNATN)
/*                                                                                          CSC020*/
/*  Call program SCC2473 to delete any journal receivers that are eligible for deletion.    CSC020*/
/*                                                                                          CSC020*/
             CALL       PGM(SCC2473)                                                      /*CSC020*/
/*                                                                                          CSC020*/
/*  Re-organise the journal sequence number file, SCJSEQPD.  Call program SCC2470.          CSC020*/
/*                                                                                          CSC020*/
             CALL       PGM(SCC2474)                                                      /*CSC020*/
/*******************************************************************************************CSC020*/
/***Delete*DLC0602*Journal*and*receiver*if*present******************************************CSC020*/
/*******************************************************************************************CSC020*/
/*/COPY WNCPYSRC,SCC0405017                                          */
/***********************************************************************CCB009**************CSC020*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),********CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************IF*********COND(&CCB009**NE*'*******')*THEN(DO)************CCB009**************CSC020*/
/************ENDJRNPF***FILE(*ALL)*JRN(JDLC0602)********************************************CSC020*/
/************MONMSG*****MSGID(CPF0000)******************************************************CSC020*/
/************DLTJRN*****JRN(JDLC0602)*******************************************************CSC020*/
/************MONMSG*****MSGID(CPF0000)******************************************************CSC020*/
/************DLTJRNRCV**JRNRCV(JRDLC0602)***************************************************CSC020*/
/************MONMSG*****MSGID(CPF0000)******************************************************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/*/COPY WNCPYSRC,SCC0405018                                          */
/**/
/*  Clear down the failed journal file PF/SCJRNERRPD               */
/**/
             CLRPFM     FILE(SCJRNERRPD)
             MONMSG     MSGID(CPF0000)
/**/
/*  Make sure that the sub-system is on before you submit          */
/*  these jobs                                                     */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&SUBSYS) VALUE('M' *CAT &SYSID *CAT +
                          'SBS')
             CHGVAR     VAR(&XLIB) VALUE(&SYSID *CAT 'XLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC0405MPE                                          */
                                                                      /*S01408*/
             STRSBS     SBSD(&XLIB/&SUBSYS)
             MONMSG     MSGID(CPF1010)
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
/*  Error processing                                               */
/**/
 ABNOR:      SNDPGMMSG  MSG('SCC0405 ENDED ABNORMALLY') +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
