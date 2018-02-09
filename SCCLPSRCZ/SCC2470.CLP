/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Monitor journal receiver size')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC2470 - Monitor Journal Receiver Size                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      260790             Date 19Jun09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSC020             Date 31Mar04              */
/*                      BUG3065            Date 10Jun04              */
/*                      CGP002             Date 04Jul03              */
/*                      CSC018             Date 31May03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      196358  *CREATE    Date 26Jun01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       260790 - COB Performance fix                                */
/*                Call SCC2470SAV to see if journal receivers should */
/*                be saved rather than wait for COB to do this       */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       BUG3065 -  Remove the changes done by CGP002.               */
/*       CGP002 - Add call to GOC000100 to update the global         */
/*                dashboard.                                         */
/*       CSC018 - Journaling options for High Availability           */
/*       196358 - Procedure to handle journal receiver overflow      */
/*                in input cycle.                                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,SCC2470INT                                          */
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CURRCV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RCVLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NEXTRCV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CURJNSTAT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RCVSIZE) TYPE(*DEC) LEN(15 0)
/*********** DCL        VAR(&RCVNBRN) TYPE(*DEC) LEN(3 0)***********************************CSC020*/
/*********** DCL        VAR(&RCVNBRA) TYPE(*CHAR) LEN(3)************************************CSC020*/
             DCL        VAR(&RCVNBRN) TYPE(*DEC) LEN(8 0)                                 /*CSC020*/
             DCL        VAR(&RCVNBRA) TYPE(*CHAR) LEN(8)                                  /*CSC020*/
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&THRESH) TYPE(*CHAR) LEN(1)
/*/COPY SDCPYSRC,SDSVALDCL                                           */                   /*CSC018*/
             DCL        VAR(&SVAL1SAV) TYPE(*CHAR) LEN(200)                               /*CSC018*/
             DCL        VAR(&SVAL2SAV) TYPE(*CHAR) LEN(200)                               /*CSC018*/
             DCL        VAR(&SVAL3SAV) TYPE(*CHAR) LEN(200)                               /*CSC018*/
             DCL        VAR(&SVAL4SAV) TYPE(*CHAR) LEN(200)                               /*CSC018*/
             DCL        VAR(&SVAL5SAV) TYPE(*CHAR) LEN(200)                               /*CSC018*/
             DCL        VAR(&SVAL6SAV) TYPE(*CHAR) LEN(200)                               /*CSC018*/
             DCL        VAR(&SVAL7SAV) TYPE(*CHAR) LEN(200)                               /*CSC018*/
             DCL        VAR(&SVAL8SAV) TYPE(*CHAR) LEN(200)                               /*CSC018*/
             DCL        VAR(&SVAL9SAV) TYPE(*CHAR) LEN(200)                               /*CSC018*/
             DCL        VAR(&SVAL10SAV) TYPE(*CHAR) LEN(200)                              /*CSC018*/
             DCL        VAR(&SUPPUPD) TYPE(*CHAR) LEN(20)                                 /*CSC018*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                                        /*CSC018*/
/* Declare variables for CSC018 - journaling optons for High Availability                 /*CSC018*/
/*                                                                                        /*CSC018*/
             DCL        VAR(&CSC018) TYPE(*CHAR) LEN(7)                                   /*CSC018*/
             DCL        VAR(&JNSEQ) TYPE(*DEC) LEN(10 0)                                  /*CSC018*/
             DCL        VAR(&SEQOPT) TYPE(*CHAR) LEN(6)                                   /*CSC018*/
             DCL        VAR(&THRES6) TYPE(*CHAR) LEN(10)                                  /*CSC018*/
             DCL        VAR(&MAXOP6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&RMVIN6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&MINFI6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
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
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                                    /*CSC018*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Clear global dashboard */                                                              /*CGP002*/
                                                                                          /*CGP002*/
/*********   CALL       PGM(GOC000100) PARM('*CLEAR')               */        /*CGP002*/ /*BUG3065*/
                                                                                          /*CGP002*/
/* Reset global dashboard */                                                              /*CGP002*/
                                                                                          /*CGP002*/
/*********   CALL       PGM(GOC000100) PARM('*ALL')                 */        /*CGP002*/ /*BUG3065*/
/*                                                                                        /*CSC018*/
/***Check*for*Switchable*feature*CSC018*(Journaling*options*for*high***         */ /*CSC018 CCB020*/
/***availability)******************************************************         */ /*CSC018 CCB020*/
/*                                                                                        /*CSC018*/
/**********  CALL       PGM(AOSARDR0) PARM(&CSC018 '*VERIFY' +
                          'CSC018' &AOFMT)                                      */ /*CSC018 CCB020*/
/*                                                                                        /*CSC018*/
/*  If feature CSC018 is present,                                                         /*CSC018*/
/*                                                                                        /*CSC018*/
/**********  IF         COND(&CSC018 *EQ '       ') THEN(DO)                    */ /*CSC018 CCB020*/
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
/*  Save contents of system values to be able to detect change.                           /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&SVAL1SAV) VALUE(&SVAL1)                                     /*CSC018*/
              CHGVAR     VAR(&SVAL2SAV) VALUE(&SVAL2)                                     /*CSC018*/
              CHGVAR     VAR(&SVAL3SAV) VALUE(&SVAL3)                                     /*CSC018*/
              CHGVAR     VAR(&SVAL4SAV) VALUE(&SVAL4)                                     /*CSC018*/
              CHGVAR     VAR(&SVAL5SAV) VALUE(&SVAL5)                                     /*CSC018*/
              CHGVAR     VAR(&SVAL6SAV) VALUE(&SVAL6)                                     /*CSC018*/
              CHGVAR     VAR(&SVAL7SAV) VALUE(&SVAL7)                                     /*CSC018*/
              CHGVAR     VAR(&SVAL8SAV) VALUE(&SVAL8)                                     /*CSC018*/
              CHGVAR     VAR(&SVAL9SAV) VALUE(&SVAL9)                                     /*CSC018*/
              CHGVAR     VAR(&SVAL10SAV) VALUE(&SVAL10)                                   /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Determine whether *MAXOPT1 or *MAXOPT2 are to be used.                                /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&MAXOP6) VALUE(%SST(&SVAL1 1 1))                             /*CSC018*/
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
/*                                                                                        /*CSC018*/
/*  and update the system value.                                                          /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(%SST(&SVAL2 1 10)) VALUE('0001500000')                      /*CSC018*/
               CALL       PGM(SD009510) PARM('HighAvlJrnRcvThld  ' +
                            &SVAL2 &SUPPUPD)                                              /*CSC018*/
/*                                                                                        /*CSC018*/
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
/*  Check whether threshold defined on the system value is too big.                       /*CSC018*/
/*  If *MAXOPT1 or *MAXOPT2 is being used,                                                /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND((&MAXOP6 *EQ '1') *OR (&MAXOP6 *EQ +
                          '2')) THEN(DO)                                                  /*CSC018*/
/*                                                                                        /*CSC018*/
/*  if the requested threshold is greater to or equal to 900 GB,                          /*CSC018*/
/*                                                                                        /*CSC018*/
               IF         COND(&THRES6 *GE '0900000000') THEN(DO)                         /*CSC018*/
/*                                                                                        /*CSC018*/
/*  set the value to a default of 10 gigabytes,                                           /*CSC018*/
/*                                                                                        /*CSC018*/
                CHGVAR     VAR(&THRES6) VALUE('0010000000')                               /*CSC018*/
                CHGVAR     VAR(&THRESHOLDK) VALUE(10000000)                               /*CSC018*/
                CHGVAR     VAR(&THRESHOLDB) VALUE(10000000000)                            /*CSC018*/
/*                                                                                        /*CSC018*/
/*  and update the system value.                                                          /*CSC018*/
/*                                                                                        /*CSC018*/
                CHGVAR     VAR(%SST(&SVAL2 1 10)) VALUE('0010000000')                     /*CSC018*/
/*                                                                                        /*CSC018*/
                CALL       PGM(SD009510) PARM('HighAvlJrnRcvThld  ' +
                             &SVAL2 &SUPPUPD)                                             /*CSC018*/
/*                                                                                        /*CSC018*/
               ENDDO                                                                      /*CSC018*/
/*                                                                                        /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  if *MAXOPT1 or *MAXOPT2 are NOT being used,                                           /*CSC018*/
/*                                                                                        /*CSC018*/
              ELSE       CMD(DO)                                                          /*CSC018*/
/*                                                                                        /*CSC018*/
/*  if the requested threshold is greater than 1.5 GB,                                    /*CSC018*/
/*                                                                                        /*CSC018*/
               IF         COND(&THRES6 *GT '0001500000') THEN(DO)                         /*CSC018*/
/*                                                                                        /*CSC018*/
/*  set the value to a default of 1.5 gigabytes,                                          /*CSC018*/
/*                                                                                        /*CSC018*/
                CHGVAR     VAR(&THRES6) VALUE('0001500000')                               /*CSC018*/
                CHGVAR     VAR(&THRESHOLDK) VALUE(1500000)                                /*CSC018*/
                CHGVAR     VAR(&THRESHOLDB) VALUE(1500000000)                             /*CSC018*/
 
/*  and update the system value.                                                          /*CSC018*/
/*                                                                                        /*CSC018*/
                CHGVAR     VAR(%SST(&SVAL2 1 10)) VALUE('0001500000')                     /*CSC018*/
/*                                                                                        /*CSC018*/
                CALL       PGM(SD009510) PARM('HighAvlJrnRcvThld  ' +
                             &SVAL2 &SUPPUPD)                                             /*CSC018*/
/*                                                                                        /*CSC018*/
               ENDDO                                                                      /*CSC018*/
/*                                                                                        /*CSC018*/
              ENDDO                                                                       /*CSC018*/
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
/*                                                                                        /*CSC018*/
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
/*                                                                                        /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Construct the variable for receiver size options.                                     /*CSC018*/
/*  Insert *MAXOPT1 or *MAXOPT2, if required.                                             /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&MAXOP6 *EQ '2') THEN(DO)                                   /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&SIZOPT1) VALUE('*MAXOPT2  ')                               /*CSC018*/
/*                                                                                        /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
              ELSE       CMD(DO)                                                          /*CSC018*/
/*                                                                                        /*CSC018*/
               IF         COND(&MAXOP6 *EQ '1') THEN(DO)                                  /*CSC018*/
/*                                                                                        /*CSC018*/
                CHGVAR     VAR(&SIZOPT1) VALUE('*MAXOPT1  ')                              /*CSC018*/
/*                                                                                        /*CSC018*/
               ENDDO                                                                      /*CSC018*/
/*                                                                                        /*CSC018*/
               ELSE       CMD(DO)                                                         /*CSC018*/
/*                                                                                        /*CSC018*/
                CHGVAR     VAR(&SIZOPT1) VALUE('          ')                              /*CSC018*/
/*                                                                                        /*CSC018*/
               ENDDO                                                                      /*CSC018*/
/*                                                                                        /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Insert *RMVINTENT, if required.                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&RMVIN6 *EQ 'Y') THEN(DO)                                   /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&SIZOPT2) VALUE('*RMVINTENT')                               /*CSC018*/
/*                                                                                        /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
              ELSE       CMD(DO)                                                          /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&SIZOPT2) VALUE('          ')                               /*CSC018*/
/*                                                                                        /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Insert *MINFIXLEN, if required.                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&MINFI6 *EQ 'Y') THEN(DO)                                   /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&SIZOPT3) VALUE('*MINFIXLEN')                               /*CSC018*/
/*                                                                                        /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
              ELSE       CMD(DO)                                                          /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&SIZOPT3) VALUE('          ')                               /*CSC018*/
/*                                                                                        /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If no options are required, insert '*NONE'.                                           /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND((&SIZOPT1 *EQ '          ') *AND +
                          (&SIZOPT2 *EQ '          ') *AND +
                          (&SIZOPT3 *EQ '          ')) THEN(DO)                           /*CSC018*/
               CHGVAR     VAR(&SIZOPT1) VALUE('*NONE')                                    /*CSC018*/
/*                                                                                        /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/** Check whether remote journaling is in use.                                            /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&RMTJR6) VALUE(%SST(&SVAL6 1 1))                             /*CSC018*/
/*                                                                                        /*CSC018*/
/* If remote journaling is in use,                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&RMTJR6 *EQ 'Y') THEN(DO)                                   /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate the remote journaling journal library.                                       /*CSC018*/
/*                                                                                        /*CSC018*/
               RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                             /*CSC018*/
               CHGVAR     VAR(&JLIBRMT) VALUE(&SYSID *CAT 'JLIBRMT ')                     /*CSC018*/
/*                                                                                        /*CSC018*/
/* Determine whether to ignore target receivers when deleting.                            /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&IGNTG6) VALUE(%SST(&SVAL7 1 1))                            /*CSC018*/
/*                                                                                        /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/** Check whether backup journal management is in use.                                    /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&MNGBJ6) VALUE(%SST(&SVAL8 1 1))                             /*CSC018*/
/*                                                                                        /*CSC018*/
/* If backup journal management is being used,                                            /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&MNGBJ6 *EQ 'Y') THEN(DO)                                   /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate the backup machine journal library.                                          /*CSC018*/
/*                                                                                        /*CSC018*/
               RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                             /*CSC018*/
               CHGVAR     VAR(&JLIBBKP) VALUE(&SYSID *CAT 'JLIB    ')                     /*CSC018*/
/*                                                                                        /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/* If remote journaling or backup journal management are in use,                          /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND((&RMTJR6 *EQ 'Y') *OR (&MNGBJ6 *EQ +
                          'Y')) THEN(DO)                                                  /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate the remote command DDM file name.                                            /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&DDMRM6) VALUE(%SST(&SVAL9 1 10))                           /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate the remote command DDM file library name.                                    /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&DDMLI6) VALUE(%SST(&SVAL10 1 10))                          /*CSC018*/
/*                                                                                        /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/**********  ENDDO                                                              */ /*CSC018 CCB020*/
/*                                                                                        /*CSC018*/
/*/COPY WNCPYSRC,SCC2470MPS                                          */
 
/* Allocate data area SCJRNLOCK to indicate program is active */
 
             ALCOBJ     OBJ((SCJRNLOCK *DTAARA *EXCL)) WAIT(9999)
 
LOOPER:
 
/* Determine currently attached receiver */
 
             RTVJRNE    JRN(ICJRN) TOENT(*FIRST) SEARCH(*DESCEND) +
                          RTNRCV(&CURRCV) RTNRCVLIB(&RCVLIB)
 
/* Determine currently attached receiver according to JNSTAT */
 
             RTVDTAARA  DTAARA(JNSTAT (1 10)) RTNVAR(&CURJNSTAT)
 
/* If receiver name stored in JNSTAT does not agree with   */
/* current receiver, then update JNSTAT with correct value */
 
             IF         COND(&CURRCV *NE &CURJNSTAT) THEN(DO)
                CHGDTAARA  DTAARA(JNSTAT (1 10)) VALUE(&CURRCV)
             ENDDO
 
/* Determine size of the currently attached receiver */
 
             RTVOBJD    OBJ(&CURRCV) OBJTYPE(*JRNRCV) SIZE(&RCVSIZE)
 
/* While we're at it, let's make sure the curently attached receiver */
/* has a threshold defined.  Call program SCC002470                  */
 
             CALL       PGM(SCC002470) PARM(&CURRCV &RCVLIB &THRESH)
 
/*                                                                                        /*CSC018*/
/**If*feature*CSC018*(Journaling*options*for*high*availability)********         */ /*CSC018 CCB020*/
/**is*NOT*switched*on.*************************************************         */ /*CSC018 CCB020*/
/**********                                                                     */ /*CSC018 CCB020*/
/**********  IF         COND(&CSC018 *NE '       ') THEN(DO)                    */ /*CSC018 CCB020*/
/**********                                                                     */ /*CSC018 CCB020*/
/**If*current*receiver*is*greater*than*1.5*gigabytes*OR*if*current                     */ /*CCB020*/
/**receiver*does*not*have*a*threshold*defined.************************                 */ /*CCB020*/
/**********                                                                            */ /*CCB020*/
/**********  IF         COND((&RCVSIZE *GT 1500000000) *OR (&THRESH +                  */ /*CCB020*/
/**********               *EQ 'N')) THEN(DO)                                           */ /*CCB020*/
/**********                                                                            */ /*CCB020*/
/**Calculate*name*of*next*receiver*in*chain***************************                 */ /*CCB020*/
/**********                                                                            */ /*CCB020*/
/************CHGVAR*****VAR(&RCVNBRA)*VALUE(%SST(&CURRCV 6 3))******************************CSC020*/
/**********  CHGVAR     VAR(&RCVNBRA) VALUE(%SST(&CURRCV 3 8))                  */ /*CSC020 CCB020*/
/**********  CHGVAR     VAR(&RCVNBRN) VALUE(&RCVNBRA)                                  */ /*CCB020*/
/**********  CHGVAR     VAR(&RCVNBRN) VALUE(&RCVNBRN + 1)                              */ /*CCB020*/
/**********  CHGVAR     VAR(&RCVNBRA) VALUE(&RCVNBRN)                                  */ /*CCB020*/
/************CHGVAR     VAR(&NEXTRCV) VALUE('ICRCV' *CAT &RCVNBRA)**************************CSC020*/
/**********  CHGVAR     VAR(&NEXTRCV) VALUE('IR' *CAT &RCVNBRA)                 */ /*CSC020 CCB020*/
 
/**delete*the*previous*day's*version*of*the*next*receiver*in**/                           /*CCB020*/
/**the*chain.*************************************************/                           /*CCB020*/
 
/**********  DLTJRNRCV  JRNRCV(&NEXTRCV) DLTOPT(*IGNINQMSG)                            */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000)                                                 */ /*CCB020*/
 
/**If*the*reciever*does*not*have*a*threshold,*create*the*next**/                          /*CCB020*/
/**receiver*with*a*threshold*of*1.5*gigabytes.*****************/                          /*CCB020*/
 
/**********  IF         COND(&THRESH *EQ 'N') THEN(DO)                                 */ /*CCB020*/
/**********     CRTJRNRCV  JRNRCV(&RCVLIB/&NEXTRCV) THRESHOLD(1500000)                 */ /*CCB020*/
 
/**Issue*a*change*journal*request*to*attach*the*new*receiver**/                           /*CCB020*/
 
/**********     CHGJRN     JRN(ICJRN) JRNRCV(&NEXTRCV)                                 */ /*CCB020*/
/*                                                                                        /*CSC020*/
/**Write*current*journal*sequence*number*to*file*SCJSEQPD,*using*command*SCWRTJREG.    */ /*CSC020*/
/*                                                                                        /*CCB020*/
/*                                                                                        /*CSC020*/
/**********  SCWRTJREG  EVENT(ICJR) TEXT('Journal receiver changed +
                          in input cycle         ')                             */ /*CSC020 CCB020*/
/*                                                                                        /*CSC020*/
/**********  ENDDO                                                                     */ /*CCB020*/
 
/**If*the*reciever*size*exceeds*1.5*gigabytes**/                                          /*CCB020*/
 
/**********  ELSE       CMD(DO)                                                        */ /*CCB020*/
 
/**Issue*a*change*journal*request*to*create*a*new*receiver**/                             /*CCB020*/
/**and*to*attach*the*journal.*******************************/                             /*CCB020*/
 
/**********     CHGJRN     JRN(ICJRN) JRNRCV(*GEN)                                     */ /*CCB020*/
/*                                                                                        /*CSC020*/
/**Write*current*journal*sequence*number*to*file*SCJSEQPD,*using*command*SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
/**********  SCWRTJREG  EVENT(ICJR) TEXT('Journal receiver changed +
                          in input cycle         ')                                       /*CSC020*/
/*                                                                                        /*CSC020*/
/**********  ENDDO                                                                     */ /*CCB020*/
 
/**Update*JNSTAT*with*the*name*of*the*new*receiver**/                                     /*CCB020*/
 
/**********     CHGDTAARA  DTAARA(JNSTAT (1 10)) VALUE(&NEXTRCV)                       */ /*CCB020*/
/**********  ENDDO                                                                     */ /*CCB020*/
/*                                                                                        /*CSC018*/
/**********  ENDDO                                                              */ /*CSC018 CCB020*/
/*                                                                                        /*CSC018*/
/**If*feature*CSC018*(Journaling*options*for*high*availability)********         */ /*CSC018 CCB020*/
/**IS*present,*********************************************************         */ /*CSC018 CCB020*/
/**********                                                                     */ /*CSC018 CCB020*/
/**********  ELSE       CMD(DO)                                                 */ /*CSC018 CCB020*/
/*                                                                                        /*CSC018*/
/* Retrieve system values to determine whether details have                               /*CSC018*/
/* changed.                                                                               /*CSC018*/
/*                                                                                        /*CSC018*/
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
/*  Determine whether *MAXOPT1 or *MAXOPT2 are to be used.                                /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&MAXOP6) VALUE(%SST(&SVAL1 1 1))                             /*CSC018*/
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
/*                                                                                        /*CSC018*/
/*  and update the system value.                                                          /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(%SST(&SVAL2 1 10)) VALUE('0001500000')                      /*CSC018*/
/*                                                                                        /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Calculate threshold value in KB.                                                      /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&THRESHOLDK) VALUE(&THRES6)                                  /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Multiply by 1000 to give value in bytes rather than KB.                               /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&THRESHOLDB) VALUE(&THRESHOLDK * 1000)                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Check whether threshold defined on the system value is too big.                       /*CSC018*/
/*  If *MAXOPT1 or *MAXOPT2 is being used,                                                /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND((&MAXOP6 *EQ '1') *OR (&MAXOP6 *EQ +
                          '2')) THEN(DO)                                                  /*CSC018*/
/*                                                                                        /*CSC018*/
/*  if the requested threshold is greater to or equal to 900 GB,                          /*CSC018*/
/*                                                                                        /*CSC018*/
               IF         COND(&THRES6 *GE '0900000000') THEN(DO)                         /*CSC018*/
/*                                                                                        /*CSC018*/
/*  set the value to a default of 10 gigabytes,                                           /*CSC018*/
/*                                                                                        /*CSC018*/
                CHGVAR     VAR(&THRES6) VALUE('0010000000')                               /*CSC018*/
                CHGVAR     VAR(&THRESHOLDK) VALUE(10000000)                               /*CSC018*/
                CHGVAR     VAR(&THRESHOLDB) VALUE(10000000000)                            /*CSC018*/
/*                                                                                        /*CSC018*/
/*  and update the system value.                                                          /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(%SST(&SVAL2 1 10)) VALUE('0010000000')                      /*CSC018*/
/*                                                                                        /*CSC018*/
               CALL       PGM(SD009510) PARM('HighAvlJrnRcvThld  ' +
                            &SVAL2 &SUPPUPD)                                              /*CSC018*/
/*                                                                                        /*CSC018*/
               ENDDO                                                                      /*CSC018*/
/*                                                                                        /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  if *MAXOPT1 or *MAXOPT2 are NOT being used,                                           /*CSC018*/
/*                                                                                        /*CSC018*/
              ELSE       CMD(DO)                                                          /*CSC018*/
/*                                                                                        /*CSC018*/
/*  if the requested threshold is greater than 1.5 GB,                                    /*CSC018*/
/*                                                                                        /*CSC018*/
               IF         COND(&THRES6 *GT '0001500000') THEN(DO)                         /*CSC018*/
/*                                                                                        /*CSC018*/
/*  set the value to a default of 1.4 gigabytes,                                          /*CSC018*/
/*                                                                                        /*CSC018*/
                CHGVAR     VAR(&THRES6) VALUE('0001500000')                               /*CSC018*/
                CHGVAR     VAR(&THRESHOLDK) VALUE(1500000)                                /*CSC018*/
                CHGVAR     VAR(&THRESHOLDB) VALUE(1500000000)                             /*CSC018*/
/*                                                                                        /*CSC018*/
/*  and update the system value.                                                          /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(%SST(&SVAL2 1 10)) VALUE('0001500000')                      /*CSC018*/
/*                                                                                        /*CSC018*/
               CALL       PGM(SD009510) PARM('HighAvlJrnRcvThld  ' +
                            &SVAL2 &SUPPUPD)                                              /*CSC018*/
/*                                                                                        /*CSC018*/
               ENDDO                                                                      /*CSC018*/
/*                                                                                        /*CSC018*/
              ENDDO                                                                       /*CSC018*/
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
/*                                                                                        /*CSC018*/
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
/*                                                                                        /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/* If current receiver is greater than the threshold defined in                           /*CSC018*/
/* the system value, OR if the current receiver does not have a                           /*CSC018*/
/* threshold defined OR if the system values have changed,                                /*CSC018*/
/*                                                                                        /*CSC018*/
              IF        COND((&RCVSIZE *GT &THRESHOLDB) +
                          *OR (&THRESH *EQ 'N') +
                          *OR (&SVAL1 *NE &SVAL1SAV) +
                          *OR (&SVAL2 *NE &SVAL2SAV) +
                          *OR (&SVAL3 *NE &SVAL3SAV) +
                          *OR (&SVAL4 *NE &SVAL4SAV) +
                          *OR (&SVAL5 *NE &SVAL5SAV) +
                          *OR (&SVAL6 *NE &SVAL6SAV) +
                          *OR (&SVAL7 *NE &SVAL7SAV) +
                          *OR (&SVAL8 *NE &SVAL8SAV) +
                          *OR (&SVAL9 *NE &SVAL9SAV) +
                          *OR (&SVAL10 *NE &SVAL10SAV)) +
                          THEN(DO)                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
/** Check whether remote journaling is in use.                                            /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&RMTJR6) VALUE(%SST(&SVAL6 1 1))                             /*CSC018*/
/*                                                                                        /*CSC018*/
/* Determine whether to ignore target receivers when deleting.                            /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&IGNTG6) VALUE(%SST(&SVAL7 1 1))                            /*CSC018*/
/*                                                                                        /*CSC018*/
/** Check whether backup journal management is in use.                                    /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&MNGBJ6) VALUE(%SST(&SVAL8 1 1))                             /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate the remote command DDM file name.                                            /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&DDMRM6) VALUE(%SST(&SVAL9 1 10))                           /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate the remote command DDM file library name.                                    /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&DDMLI6) VALUE(%SST(&SVAL10 1 10))                          /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Construct the variable for receiver size options.                                     /*CSC018*/
/*  Insert *MAXOPT1 or *MAXOPT2, if required.                                             /*CSC018*/
/*                                                                                        /*CSC018*/
               IF         COND(&MAXOP6 *EQ '2') THEN(DO)                                  /*CSC018*/
/*                                                                                        /*CSC018*/
                CHGVAR     VAR(&SIZOPT1) VALUE('*MAXOPT2  ')                              /*CSC018*/
/*                                                                                        /*CSC018*/
               ENDDO                                                                      /*CSC018*/
/*                                                                                        /*CSC018*/
               ELSE       CMD(DO)                                                         /*CSC018*/
/*                                                                                        /*CSC018*/
                IF         COND(&MAXOP6 *EQ '1') THEN(DO)                                 /*CSC018*/
/*                                                                                        /*CSC018*/
                 CHGVAR     VAR(&SIZOPT1) VALUE('*MAXOPT1  ')                             /*CSC018*/
/*                                                                                        /*CSC018*/
                ENDDO                                                                     /*CSC018*/
/*                                                                                        /*CSC018*/
                ELSE       CMD(DO)                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
                 CHGVAR     VAR(&SIZOPT1) VALUE('          ')                             /*CSC018*/
/*                                                                                        /*CSC018*/
                ENDDO                                                                     /*CSC018*/
/*                                                                                        /*CSC018*/
               ENDDO                                                                      /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Insert *RMVINTENT, if required.                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
               IF         COND(&RMVIN6 *EQ 'Y') THEN(DO)                                  /*CSC018*/
/*                                                                                        /*CSC018*/
                CHGVAR     VAR(&SIZOPT2) VALUE('*RMVINTENT')                              /*CSC018*/
/*                                                                                        /*CSC018*/
               ENDDO                                                                      /*CSC018*/
/*                                                                                        /*CSC018*/
               ELSE       CMD(DO)                                                         /*CSC018*/
/*                                                                                        /*CSC018*/
                CHGVAR     VAR(&SIZOPT2) VALUE('          ')                              /*CSC018*/
/*                                                                                        /*CSC018*/
               ENDDO                                                                      /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Insert *MINFIXLEN, if required.                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
               IF         COND(&MINFI6 *EQ 'Y') THEN(DO)                                  /*CSC018*/
/*                                                                                        /*CSC018*/
                CHGVAR     VAR(&SIZOPT3) VALUE('*MINFIXLEN')                              /*CSC018*/
/*                                                                                        /*CSC018*/
               ENDDO                                                                      /*CSC018*/
/*                                                                                        /*CSC018*/
               ELSE       CMD(DO)                                                         /*CSC018*/
/*                                                                                        /*CSC018*/
                CHGVAR     VAR(&SIZOPT3) VALUE('          ')                              /*CSC018*/
/*                                                                                        /*CSC018*/
               ENDDO                                                                      /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If no options are required, insert '*NONE'.                                           /*CSC018*/
/*                                                                                        /*CSC018*/
               IF         COND((&SIZOPT1 *EQ '          ') *AND +
                          (&SIZOPT2 *EQ '          ') *AND +
                          (&SIZOPT3 *EQ '          ')) THEN(DO)                           /*CSC018*/
/*                                                                                        /*CSC018*/
                CHGVAR     VAR(&SIZOPT1) VALUE('*NONE')                                   /*CSC018*/
/*                                                                                        /*CSC018*/
               ENDDO                                                                      /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate name of next receiver in chain                                               /*CSC018*/
/*                                                                                        /*CSC018*/
/**************CHGVAR*****VAR(&RCVNBRA)*VALUE(%SST(&CURRCV 6 3))*******************CSC018***CSC020*/
               CHGVAR     VAR(&RCVNBRA) VALUE(%SST(&CURRCV 3 8))                          /*CSC020*/
               CHGVAR     VAR(&RCVNBRN) VALUE(&RCVNBRA)                                   /*CSC018*/
               CHGVAR     VAR(&RCVNBRN) VALUE(&RCVNBRN + 1)                               /*CSC018*/
               CHGVAR     VAR(&RCVNBRA) VALUE(&RCVNBRN)                                   /*CSC018*/
/**************CHGVAR     VAR(&NEXTRCV) VALUE('ICRCV' *CAT &RCVNBRA)************CSC018******CSC020*/
               CHGVAR     VAR(&NEXTRCV) VALUE('IR' *CAT &RCVNBRA)                         /*CSC020*/
/*                                                                                        /*CSC018*/
/* delete the previous day's version of the next receiver in                              /*CSC018*/
/* the chain.                                                                             /*CSC018*/
/*                                                                                        /*CSC018*/
/* If remote journaling is being used and if 'Ignore                                      /*CSC018*/
/* Target Receiver' is 'Y', then delete receiver with option *IGNTGTRCV                   /*CSC018*/
/*                                                                                        /*CSC018*/
               IF       COND((&RMTJR6 *EQ 'Y') *AND (&IGNTG6 *EQ +
                          'Y')) THEN(DO)                                                  /*CSC018*/
/*                                                                                        /*CSC018*/
                DLTJRNRCV  JRNRCV(&NEXTRCV) DLTOPT(*IGNTGTRCV +
                          *IGNINQMSG)                                                     /*CSC018*/
                MONMSG     MSGID(CPF0000)                                                 /*CSC018*/
/*                                                                                        /*CSC018*/
               ENDDO                                                                      /*CSC018*/
/*                                                                                        /*CSC018*/
               ELSE       CMD(DO)                                                         /*CSC018*/
/*                                                                                        /*CSC018*/
                DLTJRNRCV  JRNRCV(&NEXTRCV) DLTOPT(*IGNINQMSG)                            /*CSC018*/
                MONMSG     MSGID(CPF0000)                                                 /*CSC018*/
/*                                                                                        /*CSC018*/
               ENDDO                                                                      /*CSC018*/
/*                                                                                        /*CSC018*/
/* If remote journaling is being used,                                                    /*CSC018*/
/*                                                                                        /*CSC018*/
               IF       COND(&RMTJR6 *EQ 'Y') THEN(DO)                                    /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate remote command to delete the next receiver.                                  /*CSC018*/
/*                                                                                        /*CSC018*/
                CHGVAR     VAR(&RMTCM6) VALUE(' ')                                        /*CSC018*/
                CHGVAR     VAR(&RMTCM6) VALUE('DLTJRNRCV ' *CAT +
                          &JLIBRMT *TCAT '/' *CAT &NEXTRCV *CAT ' +
                          DLTOPT(*IGNINQMSG)')                                            /*CSC018*/
/*                                                                                        /*CSC018*/
/* Execute the remote command to delete the next receiver in the remote                   /*CSC018*/
/* journaling library on the other machine.                                               /*CSC018*/
/*                                                                                        /*CSC018*/
                SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)                          /*CSC018*/
                MONMSG     MSGID(CPF0000 MCH0000)                                         /*CSC018*/
/*                                                                                        /*CSC018*/
               ENDDO                                                                      /*CSC018*/
/*                                                                                        /*CSC018*/
/* If backup journal management is being used,                                            /*CSC018*/
/*                                                                                        /*CSC018*/
               IF       COND(&MNGBJ6 *EQ 'Y') THEN(DO)                                    /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate remote command to delete the next receiver.                                  /*CSC018*/
/*                                                                                        /*CSC018*/
                CHGVAR     VAR(&RMTCM6) VALUE(' ')                                        /*CSC018*/
                CHGVAR   VAR(&RMTCM6) VALUE('DLTJRNRCV JRNRCV(' *CAT +
                          &JLIBBKP *TCAT '/' *CAT &NEXTRCV *TCAT ') +
                          DLTOPT(*IGNINQMSG)')                                            /*CSC018*/
/*                                                                                        /*CSC018*/
/* Execute the remote command to delete receiver ICRCV001 in the                          /*CSC018*/
/* journaling library on the backup machine.                                              /*CSC018*/
/*                                                                                        /*CSC018*/
                SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)                          /*CSC018*/
                MONMSG     MSGID(CPF0000 MCH0000)                                         /*CSC018*/
/*                                                                                        /*CSC018*/
               ENDDO                                                                      /*CSC018*/
/*                                                                                        /*CSC018*/
/* If the receiver does not have a threshold, or, if the system values                    /*CSC018*/
/* have changed, create a new receiver with a threshold                                   /*CSC018*/
/* as defined in the system values.                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
               IF     COND((&THRESH *EQ 'N') +
                        *OR (&SVAL1 *NE &SVAL1SAV) +
                        *OR (&SVAL2 *NE &SVAL2SAV) +
                        *OR (&SVAL3 *NE &SVAL3SAV) +
                        *OR (&SVAL4 *NE &SVAL4SAV) +
                        *OR (&SVAL5 *NE &SVAL5SAV) +
                        *OR (&SVAL6 *NE &SVAL6SAV) +
                        *OR (&SVAL7 *NE &SVAL7SAV) +
                        *OR (&SVAL8 *NE &SVAL8SAV) +
                        *OR (&SVAL9 *NE &SVAL9SAV) +
                        *OR (&SVAL10 *NE &SVAL10SAV)) +
                          THEN(DO)                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
                CRTJRNRCV  JRNRCV(&RCVLIB/&NEXTRCV) +
                          THRESHOLD(&THRESHOLDK)                                          /*CSC018*/
/*                                                                                        /*CSC018*/
/* If backup journal management is being used,                                            /*CSC018*/
/*                                                                                        /*CSC018*/
                IF       COND(&MNGBJ6 *EQ 'Y') THEN(DO)                                   /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate remote command to create receiver ICRCV001.                                  /*CSC018*/
/*                                                                                        /*CSC018*/
                 CHGVAR     VAR(&RMTCM6) VALUE(' ')                                       /*CSC018*/
                 CHGVAR  VAR(&RMTCM6) VALUE('CRTJRNRCV JRNRCV(' *CAT +
                          &JLIBBKP *TCAT '/' *CAT &NEXTRCV *TCAT ') +
                          THRESHOLD(' *CAT &THRES6 *TCAT ')')                             /*CSC018*/
/*                                                                                        /*CSC018*/
/* Execute the remote command to create receiver ICRCV001 in the                          /*CSC018*/
/* journaling library on the backup machine.                                              /*CSC018*/
/*                                                                                        /*CSC018*/
                 SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)                         /*CSC018*/
                 MONMSG     MSGID(CPF0000 MCH0000)                                        /*CSC018*/
/*                                                                                        /*CSC018*/
                ENDDO                                                                     /*CSC018*/
/*                                                                                        /*CSC018*/
/* Issue a change journal request to attach the new receiver                              /*CSC018*/
/*                                                                                        /*CSC018*/
                CHGVAR     VAR(&CMD) VALUE(' ')                                           /*CSC018*/
                IF      COND(&SIZOPT1 *NE '*NONE') THEN(DO)                               /*CSC018*/
                 CHGVAR  VAR(&CMD) VALUE('CHGJRN JRN(ICJRN) JRNRCV('   +
                          *CAT &NEXTRCV *TCAT ') RCVSIZOPT(' *CAT +
                          &SIZOPT1 *BCAT &SIZOPT2 *BCAT &SIZOPT3 +
                          *TCAT ')')                                                      /*CSC018*/
                ENDDO                                                                     /*CSC018*/
                ELSE       CMD(DO)                                                        /*CSC018*/
                 CHGVAR     VAR(&CMD) VALUE('CHGJRN JRN(ICJRN) JRNRCV(' +
                          *CAT &NEXTRCV *TCAT ')')                                        /*CSC018*/
                ENDDO                                                                     /*CSC018*/
                CALL       PGM(QCMDEXC) PARM(&CMD 150)                                    /*CSC018*/
                MONMSG     MSGID(CPF70F6)                                                 /*CSC018*/
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             SCWRTJREG  EVENT(ICJR) TEXT('Journal receiver changed +
                          in input cycle         ')                                       /*CSC020*/
/*                                                                                        /*CSC018*/
/* Update JNSTAT with the name of the new receiver.                                       /*CSC018*/
/*                                                                                        /*CSC018*/
                CHGDTAARA  DTAARA(JNSTAT (1 10)) VALUE(&NEXTRCV)                          /*CSC018*/
/*                                                                                        /*CSC018*/
/* If backup journal management is being used,                                            /*CSC018*/
/*                                                                                        /*CSC018*/
                IF      COND(&MNGBJ6 *EQ 'Y') THEN(DO)                                    /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate remote command to execute CHGJRN command.                                    /*CSC018*/
/*                                                                                        /*CSC018*/
                 CHGVAR     VAR(&RMTCM6) VALUE(' ')                                       /*CSC018*/
                 IF      COND(&SIZOPT1 *NE '*NONE') THEN(DO)                              /*CSC018*/
                  CHGVAR     VAR(&RMTCM6) VALUE('CHGJRN JRN(' *CAT +
                          &JLIBBKP *TCAT '/ICJRN) JRNRCV(' *CAT +
                          &JLIBBKP *TCAT '/' *CAT &NEXTRCV *TCAT ') +
                          RCVSIZOPT(' *CAT &SIZOPT1 *BCAT &SIZOPT2 +
                          *BCAT &SIZOPT3 *TCAT ')')                                       /*CSC018*/
                 ENDDO                                                                    /*CSC018*/
                 ELSE       CMD(DO)                                                       /*CSC018*/
                  CHGVAR     VAR(&RMTCM6) VALUE('CHGJRN JRN(' *CAT +
                          &JLIBBKP *TCAT '/ICJRN) JRNRCV(' *CAT +
                          &JLIBBKP *TCAT '/' *CAT &NEXTRCV *TCAT ')')                     /*CSC018*/
                 ENDDO                                                                    /*CSC018*/
/*                                                                                        /*CSC018*/
/* Execute the remote command to execute the CHGJRN command on the                        /*CSC018*/
/* backup machine.                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
                 SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)                         /*CSC018*/
                 MONMSG     MSGID(CPF0000 MCH0000)                                        /*CSC018*/
/*                                                                                        /*CSC018*/
                ENDDO                                                                     /*CSC018*/
/*                                                                                        /*CSC018*/
               ENDDO                                                                      /*CSC018*/
                                                                                          /*CSC018*/
/* If the receiver size exceeds threshold,                                                /*CSC018*/
                                                                                          /*CSC018*/
               ELSE       CMD(DO)                                                         /*CSC018*/
                                                                                          /*CSC018*/
/* Issue a change journal request to create a new receiver                                /*CSC018*/
/* and to attach the journal.                                                             /*CSC018*/
                                                                                          /*CSC018*/
                CHGVAR     VAR(&CMD) VALUE(' ')                                           /*CSC018*/
                IF      COND(&SIZOPT1 *NE '*NONE') THEN(DO)                               /*CSC018*/
                 CHGVAR     VAR(&CMD) VALUE('CHGJRN JRN(ICJRN) +
                          JRNRCV(*GEN) RCVSIZOPT(' *CAT +
                          &SIZOPT1 *BCAT &SIZOPT2 *BCAT &SIZOPT3 +
                          *TCAT ')')                                                      /*CSC018*/
                ENDDO                                                                     /*CSC018*/
                ELSE       CMD(DO)                                                        /*CSC018*/
                 CHGVAR     VAR(&CMD) VALUE('CHGJRN JRN(ICJRN) +
                          JRNRCV(*GEN)')                                                  /*CSC018*/
                ENDDO                                                                     /*CSC018*/
                CALL       PGM(QCMDEXC) PARM(&CMD 150)                                    /*CSC018*/
                MONMSG     MSGID(CPF70F6)                                                 /*CSC018*/
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             SCWRTJREG  EVENT(ICJR) TEXT('Journal receiver changed +
                          in input cycle         ')                                       /*CSC020*/
/*                                                                                        /*CSC018*/
/* Determine the newly attached receiver                                                  /*CSC018*/
/*                                                                                        /*CSC018*/
                RTVJRNE  JRN(ICJRN) TOENT(*FIRST) SEARCH(*DESCEND) +
                          RTNRCV(&CURRCV) RTNRCVLIB(&RCVLIB)
/*                                                                                        /*CSC018*/
/* Update JNSTAT with the name of the new receiver.                                       /*CSC018*/
/*                                                                                        /*CSC018*/
                CHGDTAARA  DTAARA(JNSTAT (1 10)) VALUE(&CURRCV)                           /*CSC018*/
/*                                                                                        /*CSC018*/
/* If backup journal management is being used,                                            /*CSC018*/
/*                                                                                        /*CSC018*/
                IF      COND(&MNGBJ6 *EQ 'Y') THEN(DO)                                    /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate remote command to execute CHGJRN command.                                    /*CSC018*/
/*                                                                                        /*CSC018*/
                 CHGVAR     VAR(&RMTCM6) VALUE(' ')                                       /*CSC018*/
                 IF      COND(&SIZOPT1 *NE '*NONE') THEN(DO)                              /*CSC018*/
                  CHGVAR     VAR(&RMTCM6) VALUE('CHGJRN JRN(' *CAT +
                          &JLIBBKP *TCAT '/ICJRN) JRNRCV(*GEN) +
                          RCVSIZOPT(' *CAT &SIZOPT1 *BCAT &SIZOPT2 +
                          *BCAT &SIZOPT3 *TCAT ')')                                       /*CSC018*/
                 ENDDO                                                                    /*CSC018*/
                 ELSE       CMD(DO)                                                       /*CSC018*/
                  CHGVAR     VAR(&RMTCM6) VALUE('CHGJRN JRN(' *CAT +
                          &JLIBBKP *TCAT '/ICJRN) JRNRCV(*GEN)')                          /*CSC018*/
                 ENDDO                                                                    /*CSC018*/
/*                                                                                        /*CSC018*/
/* Execute the remote command to execute the CHGJRN command on the                        /*CSC018*/
/* backup machine.                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
                 SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)                         /*CSC018*/
                 MONMSG     MSGID(CPF0000 MCH0000)                                        /*CSC018*/
/*                                                                                        /*CSC018*/
                ENDDO                                                                     /*CSC018*/
/*                                                                                        /*CSC018*/
               ENDDO                                                                      /*CSC018*/
/*                                                                                        /*CSC018*/
/* If system values changed, save the new value for later comparison.                     /*CSC018*/
/*                                                                                        /*CSC018*/
               IF     COND((&SVAL1 *NE &SVAL1SAV) +
                        *OR (&SVAL2 *NE &SVAL2SAV) +
                        *OR (&SVAL3 *NE &SVAL3SAV) +
                        *OR (&SVAL4 *NE &SVAL4SAV) +
                        *OR (&SVAL5 *NE &SVAL5SAV) +
                        *OR (&SVAL6 *NE &SVAL6SAV) +
                        *OR (&SVAL7 *NE &SVAL7SAV) +
                        *OR (&SVAL8 *NE &SVAL8SAV) +
                        *OR (&SVAL9 *NE &SVAL9SAV) +
                        *OR (&SVAL10 *NE &SVAL10SAV)) +
                          THEN(DO)                                                        /*CSC018*/
                  CHGVAR     VAR(&SVAL1SAV) VALUE(&SVAL1)                                 /*CSC018*/
                  CHGVAR     VAR(&SVAL2SAV) VALUE(&SVAL2)                                 /*CSC018*/
                  CHGVAR     VAR(&SVAL3SAV) VALUE(&SVAL3)                                 /*CSC018*/
                  CHGVAR     VAR(&SVAL4SAV) VALUE(&SVAL4)                                 /*CSC018*/
                  CHGVAR     VAR(&SVAL5SAV) VALUE(&SVAL5)                                 /*CSC018*/
                  CHGVAR     VAR(&SVAL6SAV) VALUE(&SVAL6)                                 /*CSC018*/
                  CHGVAR     VAR(&SVAL7SAV) VALUE(&SVAL7)                                 /*CSC018*/
                  CHGVAR     VAR(&SVAL8SAV) VALUE(&SVAL8)                                 /*CSC018*/
                  CHGVAR     VAR(&SVAL9SAV) VALUE(&SVAL9)                                 /*CSC018*/
                  CHGVAR     VAR(&SVAL10SAV) VALUE(&SVAL10)                               /*CSC018*/
               ENDDO                                                                      /*CSC018*/
/*                                                                                        /*CSC018*/
/* Update JNSTAT with the name of the new receiver                                        /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGDTAARA  DTAARA(JNSTAT (1 10)) VALUE(&NEXTRCV)                           /*CSC018*/
/*                                                                                        /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/**********  ENDDO                                                              */ /*CSC018 CCB020*/
 
/**/                                                                                      /*260790*/
/* Call SCC2470SAV to ensure that the journal receivers are saved */                      /*260790*/
/* straight away if journal receivers are saved to DISK. As a result */                   /*260790*/
/* SCC0401 and SCC0405 should complete very quickly rather than */                        /*260790*/
/* taking a long time. */                                                                 /*260790*/
/**/                                                                                      /*260790*/
             CALL       PGM(SCC2470SAV)                                                   /*260790*/
                                                                                          /*CGP002*/
/* Update global dashboard */                                                             /*CGP002*/
                                                                                          /*CGP002*/
/*********   CALL       PGM(GOC000100) PARM('*PHASE')               */        /*CGP002*/ /*BUG3065*/
                                                                                          /*CGP002*/
/* Delay job for 10 minutes */
 
             DLYJOB     DLY(600)
 
/* Retrieve data area MPHAS */
 
             RTVDTAARA  DTAARA(MPHAS *ALL) RTNVAR(&MPHAS)
 
/**If*MPHAS*is*not*'A',*then*end*job**/                                                   /*CCB020*/
/** If MPHAS is not 'A' nor 'G', then end job */                                          /*CCB020*/
 
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                                     /*CCB020*/
             IF         COND(&MPHAS *NE 'A' *AND &MPHAS *NE 'G') +
                          THEN(DO)                                                        /*CCB020*/
                GOTO       CMDLBL(END)
             ENDDO
 
/* Repeat cycle of processing */
 
             GOTO       CMDLBL(LOOPER)
 
/*/COPY WNCPYSRC,SCC2470MPE                                          */
 
             GOTO       CMDLBL(END)
 
ABNOR:
/*/COPY WNCPYSRC,SCC2470ERR                                          */
 
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             SNDPGMMSG  MSG('Program SCC2470 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:
/*/COPY WNCPYSRC,SCC2470END                                          */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
