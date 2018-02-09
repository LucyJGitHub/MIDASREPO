/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Global journal monitor')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC2477 - Monitor Global Journal                            */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1082949          Date 20May13              */
/*                      CCB020             Date 06Aug12              */
/*                      CSC043             Date 18Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG5729            Date 10Feb04              */
/*                      CSC020  *CREATE    Date 31Mar04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1082949 - GPJRN journal sequence is not resetting.        */
/*                   Reset of the GPJRN journal sequence number.     */
/*                   (Child: AR1082950).                             */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       CSC043 - MidasPlus IASP Enablement                          */
/*       BUG5729 - BoI Build 89 - Global journal monitor calculates  */
/*                 incorrect journal library name.                   */
/*       CSC020 - Journaling changes for MidasPlus                   */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,SCC2477INT                                                                       */
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CURRCV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RCVLIB) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&GPGXLIB) TYPE(*CHAR) LEN(10)  */                             /*CSC043*/
             DCL        VAR(&GPGJLIB) TYPE(*CHAR) LEN(10)                                 /*CSC043*/
             DCL        VAR(&NEXTRCV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RCVSIZE) TYPE(*DEC) LEN(15 0)
             DCL        VAR(&RCVNBRN) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&RCVNBRA) TYPE(*CHAR) LEN(8)
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                                 */ /*CCB020*/
             DCL        VAR(&THRESH) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CHANGE) TYPE(*CHAR) LEN(1)
/*/COPY GPCPYSRCG,GPSVALDCL                                                                       */
             DCL        VAR(&SVAL1SAV) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SVAL2SAV) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SVAL3SAV) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SVAL4SAV) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SVAL5SAV) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SVAL6SAV) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SVAL7SAV) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SVAL8SAV) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SVAL9SAV) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SVAL10SAV) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SUPPUPD) TYPE(*CHAR) LEN(20)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2004')
             DCL        VAR(&JNSEQ) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&SEQOPT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&THRES6) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CNTSE6) TYPE(*CHAR) LEN(1)                                /*AR1082949*/
             DCL        VAR(&MAXOP6) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RMVIN6) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MINFI6) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RMTJR6) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MNGBJ6) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DDMRM6) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DDMLI6) TYPE(*CHAR) LEN(10)
             DCL        VAR(&IGNTG6) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JLIBRMT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RMTCM6) TYPE(*CHAR) LEN(150)
             DCL        VAR(&JLIBBKP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&THRESHOLDB) TYPE(*DEC) LEN(15 0)
             DCL        VAR(&THRESHOLDK) TYPE(*DEC) LEN(15 0)
             DCL        VAR(&SIZOPT1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SIZOPT2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SIZOPT3) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(150)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RCVDATTIM) TYPE(*CHAR) LEN(13)
             DCL        VAR(&RCVDAT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CURDATTIM) TYPE(*CHAR) LEN(13)
             DCL        VAR(&CURDAT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CURTIM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CHGBASIS) TYPE(*CHAR) LEN(4)
             DCL        VAR(&CHGTIM) TYPE(*CHAR) LEN(6)
 
/* Global monitor message                                                                         */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*  Get the high availability system values                                                       */
 
             CALL       PGM(GPAOSVALR0) PARM(&RSVALRTNC +
                             'GlobalRcvSizeOption' &SVAL1 +
                             'GlobalJrnRcvThld' &SVAL2 +
                             'GlobalRmvIntJrnEnt' &SVAL3 +
                             'GlobalMinFixLenJrnE' &SVAL4 +
                             'GlobalContJrnSeqNum' &SVAL5 +
                             'GlobalRmtJrnActive' &SVAL6 +
                             'GlobalIgnTgtOnDel' &SVAL7 +
                             'GlobalMangBackUpJrn' &SVAL8 +
                             'GlobalDdmFileName' &SVAL9 +
                             'GlobalDdmFileLib' &SVAL10)
 
/* If there is an error finding any system value then end abnormally                              */
 
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))
/*                                                                                                */
             CALL       PGM(GPAOSVALR0) PARM(&RSVALRTNC +
                          'GlobalJrnChangeBasis' &SVAL11 +
                          'GlobalJrnChangeTime' &SVAL12 &SVALK13 +
                          &SVAL13 &SVALK14 &SVAL14 &SVALK15 &SVAL15 +
                          &SVALK16 &SVAL16 &SVALK17 &SVAL17 +
                          &SVALK18 &SVAL18 &SVALK19 &SVAL19 +
                          &SVALK20 &SVAL20)
 
/* If there is an error finding any system value then end abnormally                              */
 
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))
/*                                                                                                */
/*  Save contents of system values to be able to detect change.                                   */
/*                                                                                                */
             CHGVAR     VAR(&SVAL1SAV) VALUE(&SVAL1)
             CHGVAR     VAR(&SVAL2SAV) VALUE(&SVAL2)
             CHGVAR     VAR(&SVAL3SAV) VALUE(&SVAL3)
             CHGVAR     VAR(&SVAL4SAV) VALUE(&SVAL4)
             CHGVAR     VAR(&SVAL5SAV) VALUE(&SVAL5)
             CHGVAR     VAR(&SVAL6SAV) VALUE(&SVAL6)
             CHGVAR     VAR(&SVAL7SAV) VALUE(&SVAL7)
             CHGVAR     VAR(&SVAL8SAV) VALUE(&SVAL8)
             CHGVAR     VAR(&SVAL9SAV) VALUE(&SVAL9)
             CHGVAR     VAR(&SVAL10SAV) VALUE(&SVAL10)
/*                                                                                                */
/*  Determine basis for changing journal receivers.                                               */
/*                                                                                                */
             CHGVAR     VAR(&CHGBASIS) VALUE(%SST(&SVAL11 1 4))
/*                                                                                                */
/*  Determine time for changing journal receivers.                                                */
/*                                                                                                */
             CHGVAR     VAR(&CHGTIM) VALUE(%SST(&SVAL12 1 6))
/*                                                                                                */
/*  Determine whether *MAXOPT1 or *MAXOPT2 are to be used.                                        */
/*                                                                                                */
             CHGVAR     VAR(&MAXOP6) VALUE(%SST(&SVAL1 1 1))
/**/                                                                                   /*AR1082949*/
/** Determine whether continuous journal sequence numbers are */                       /*AR1082949*/
/** being used. */                                                                     /*AR1082949*/
/**/                                                                                   /*AR1082949*/
             CHGVAR     VAR(&CNTSE6) VALUE(%SST(&SVAL5 1 1))                           /*AR1082949*/
/*                                                                                                */
/*  Determine journal receiver threshold.                                                         */
/*                                                                                                */
             CHGVAR     VAR(&THRES6) VALUE(%SST(&SVAL2 1 10))
/*                                                                                                */
/*  If threshold is blank on the system value file.                                               */
/*                                                                                                */
             IF         COND(&THRES6 *EQ '          ') THEN(DO)
/*                                                                                                */
/*  set the value to a default of 1.5 gigabytes,                                                  */
/*                                                                                                */
              CHGVAR     VAR(&THRES6) VALUE('0001500000')
/*                                                                                                */
/*  and update the system value.                                                                  */
/*                                                                                                */
              CHGVAR     VAR(%SST(&SVAL2 1 10)) VALUE('0001500000')
              CALL       PGM(GP009510) PARM('GlobalJrnRcvThld  ' +
                            &SVAL2 &SUPPUPD)
/*                                                                                                */
             ENDDO
/*                                                                                                */
/*  Calculate threshold value in KB.                                                              */
/*                                                                                                */
             CHGVAR     VAR(&THRESHOLDK) VALUE(&THRES6)
/*                                                                                                */
/*  Multiply by 1000 to give value in bytes.                                                      */
/*                                                                                                */
             CHGVAR     VAR(&THRESHOLDB) VALUE(&THRESHOLDK * 1000)
/*                                                                                                */
/*  Check whether threshold defined on the system value is too big.                               */
/*  If *MAXOPT1 or *MAXOPT2 is being used,                                                        */
/*                                                                                                */
             IF         COND((&MAXOP6 *EQ '1') *OR (&MAXOP6 *EQ +
                          '2')) THEN(DO)
/*                                                                                                */
/*  if the requested threshold is greater to or equal to 900 GB,                                  */
/*                                                                                                */
              IF         COND(&THRES6 *GE '0900000000') THEN(DO)
/*                                                                                                */
/*  set the value to a default of 10 gigabytes,                                                   */
/*                                                                                                */
               CHGVAR     VAR(&THRES6) VALUE('0010000000')
               CHGVAR     VAR(&THRESHOLDK) VALUE(10000000)
               CHGVAR     VAR(&THRESHOLDB) VALUE(10000000000)
/*                                                                                                */
/*  and update the system value.                                                                  */
/*                                                                                                */
               CHGVAR     VAR(%SST(&SVAL2 1 10)) VALUE('0010000000')
/*                                                                                                */
               CALL       PGM(GP009510) PARM('GlobalJrnRcvThld  ' +
                             &SVAL2 &SUPPUPD)
/*                                                                                                */
              ENDDO
/*                                                                                                */
             ENDDO
/*                                                                                                */
/*  if *MAXOPT1 or *MAXOPT2 are NOT being used,                                                   */
/*                                                                                                */
             ELSE       CMD(DO)
/*                                                                                                */
/*  if the requested threshold is greater than 1.5 GB,                                            */
/*                                                                                                */
              IF         COND(&THRES6 *GT '0001500000') THEN(DO)
/*                                                                                                */
/*  set the value to a default of 1.5 gigabytes,                                                  */
/*                                                                                                */
               CHGVAR     VAR(&THRES6) VALUE('0001500000')
               CHGVAR     VAR(&THRESHOLDK) VALUE(1500000)
               CHGVAR     VAR(&THRESHOLDB) VALUE(1500000000)
 
/*  and update the system value.                                                                  */
/*                                                                                                */
               CHGVAR     VAR(%SST(&SVAL2 1 10)) VALUE('0001500000')
/*                                                                                                */
               CALL       PGM(GP009510) PARM('GlobalJrnRcvThld  ' +
                             &SVAL2 &SUPPUPD)
/*                                                                                                */
              ENDDO
/*                                                                                                */
             ENDDO
/*                                                                                                */
/*  Determine whether internal journal entries are to be removed.                                 */
/*                                                                                                */
             CHGVAR     VAR(&RMVIN6) VALUE(%SST(&SVAL3 1 1))
/*                                                                                                */
/*  If value is blank on the system value file.                                                   */
/*                                                                                                */
             IF         COND(&RMVIN6 *EQ ' ') THEN(DO)
/*                                                                                                */
/*  set a default value of 'N',                                                                   */
/*                                                                                                */
              CHGVAR     VAR(&RMVIN6) VALUE('N')
/*                                                                                                */
/*  and update the system value file.                                                             */
/*                                                                                                */
              CHGVAR     VAR(%SST(&SVAL3 1 1)) VALUE('N')
              CALL       PGM(GP009510) PARM('GlobalRmvIntJrnEnt' +
                            &SVAL3 &SUPPUPD)
/*                                                                                                */
             ENDDO
/*                                                                                                */
/*  Determine whether miminal fixed length journal entries are                                    */
/*  required.  (Not recommended!!)                                                                */
/*                                                                                                */
             CHGVAR     VAR(&MINFI6) VALUE(%SST(&SVAL4 1 1))
/*                                                                                                */
/*  If value is blank on the system value file.                                                   */
/*                                                                                                */
             IF         COND(&MINFI6 *EQ ' ') THEN(DO)
/*                                                                                                */
/*  set a default value of 'N',                                                                   */
/*                                                                                                */
              CHGVAR     VAR(&MINFI6) VALUE('N')
/*                                                                                                */
/*  and update the system value.                                                                  */
/*                                                                                                */
              CHGVAR     VAR(%SST(&SVAL4 1 1)) VALUE('N')
              CALL       PGM(GP009510) PARM('GlobalMinFixLenJrnE' +
                            &SVAL4 &SUPPUPD)
/*                                                                                                */
             ENDDO
/*                                                                                                */
/*  Construct the variable for receiver size options.                                             */
/*  Insert *MAXOPT1 or *MAXOPT2, if required.                                                     */
/*                                                                                                */
             IF         COND(&MAXOP6 *EQ '2') THEN(DO)
/*                                                                                                */
              CHGVAR     VAR(&SIZOPT1) VALUE('*MAXOPT2  ')
/*                                                                                                */
             ENDDO
/*                                                                                                */
             ELSE       CMD(DO)
/*                                                                                                */
              IF         COND(&MAXOP6 *EQ '1') THEN(DO)
/*                                                                                                */
               CHGVAR     VAR(&SIZOPT1) VALUE('*MAXOPT1  ')
/*                                                                                                */
              ENDDO
/*                                                                                                */
              ELSE       CMD(DO)
/*                                                                                                */
               CHGVAR     VAR(&SIZOPT1) VALUE('          ')
/*                                                                                                */
              ENDDO
/*                                                                                                */
             ENDDO
/*                                                                                                */
/*  Insert *RMVINTENT, if required.                                                               */
/*                                                                                                */
             IF         COND(&RMVIN6 *EQ 'Y') THEN(DO)
/*                                                                                                */
              CHGVAR     VAR(&SIZOPT2) VALUE('*RMVINTENT')
/*                                                                                                */
             ENDDO
/*                                                                                                */
             ELSE       CMD(DO)
/*                                                                                                */
              CHGVAR     VAR(&SIZOPT2) VALUE('          ')
/*                                                                                                */
             ENDDO
/*                                                                                                */
/*  Insert *MINFIXLEN, if required.                                                               */
/*                                                                                                */
             IF         COND(&MINFI6 *EQ 'Y') THEN(DO)
/*                                                                                                */
              CHGVAR     VAR(&SIZOPT3) VALUE('*MINFIXLEN')
/*                                                                                                */
             ENDDO
/*                                                                                                */
             ELSE       CMD(DO)
/*                                                                                                */
              CHGVAR     VAR(&SIZOPT3) VALUE('          ')
/*                                                                                                */
             ENDDO
/*                                                                                                */
/*  If no options are required, insert '*NONE'.                                                   */
/*                                                                                                */
             IF         COND((&SIZOPT1 *EQ '          ') *AND +
                          (&SIZOPT2 *EQ '          ') *AND +
                          (&SIZOPT3 *EQ '          ')) THEN(DO)
              CHGVAR     VAR(&SIZOPT1) VALUE('*NONE')
/*                                                                                                */
             ENDDO
/*                                                                                                */
/** Check whether remote journaling is in use.                                                    */
/*                                                                                                */
             CHGVAR     VAR(&RMTJR6) VALUE(%SST(&SVAL6 1 1))
/*                                                                                                */
/* If remote journaling is in use,                                                                */
/*                                                                                                */
             IF         COND(&RMTJR6 *EQ 'Y') THEN(DO)
/*                                                                                                */
/* Calculate the remote journaling journal library.                                               */
/*                                                                                                */
/**********   RTVOBJD    OBJ(GPJRN) OBJTYPE(*JRN) RTNLIB(&GPGXLIB)    */                  /*CSC043*/
/**********   CHGVAR     VAR(&SYSID) VALUE(%SST(&GPGXLIB 1 2))        */                  /*CSC043*/
/**********   CHGVAR     VAR(&JLIBRMT) VALUE(&SYSID *CAT 'GXLIBRMT')  */                  /*CSC043*/
              RTVOBJD    OBJ(GPJRN) OBJTYPE(*JRN) RTNLIB(&GPGJLIB)                        /*CSC043*/
              CHGVAR     VAR(&SYSID) VALUE(%SST(&GPGJLIB 1 2))                            /*CSC043*/
              CHGVAR     VAR(&JLIBRMT) VALUE(&SYSID *CAT 'GJLIBRMT')                      /*CSC043*/
/*                                                                                                */
/* Determine whether to ignore target receivers when deleting.                                    */
/*                                                                                                */
              CHGVAR     VAR(&IGNTG6) VALUE(%SST(&SVAL7 1 1))
/*                                                                                                */
             ENDDO
/*                                                                                                */
/** Check whether backup journal management is in use.                                            */
/*                                                                                                */
             CHGVAR     VAR(&MNGBJ6) VALUE(%SST(&SVAL8 1 1))
/*                                                                                                */
/* If backup journal management is being used,                                                    */
/*                                                                                                */
             IF         COND(&MNGBJ6 *EQ 'Y') THEN(DO)
/*                                                                                                */
/* Calculate the backup machine journal library.                                                  */
/*                                                                                                */
/**********   RTVOBJD    OBJ(GPJRN) OBJTYPE(*JRN) RTNLIB(&GPGXLIB)  */                    /*CSC043*/
/**********   CHGVAR     VAR(&SYSID) VALUE(%SST(&GPGXLIB 1 2))      */                    /*CSC043*/
              RTVOBJD    OBJ(GPJRN) OBJTYPE(*JRN) RTNLIB(&GPGJLIB)                        /*CSC043*/
              CHGVAR     VAR(&SYSID) VALUE(%SST(&GPGJLIB 1 2))                            /*CSC043*/
/**********   CHGVAR     VAR(&JLIBBKP) VALUE(&SYSID *CAT 'JLIB    ')*/                   /*BUG5729*/
/**********   CHGVAR     VAR(&JLIBBKP) VALUE(&SYSID *CAT 'GXLIB   ')*/            /*BUG5729 CSC043*/
              CHGVAR     VAR(&JLIBBKP) VALUE(&SYSID *CAT 'GJLIB   ')                      /*CSC043*/
/*                                                                                                */
             ENDDO
/*                                                                                                */
/* If remote journaling or backup journal management are in use,                                  */
/*                                                                                                */
             IF         COND((&RMTJR6 *EQ 'Y') *OR (&MNGBJ6 *EQ +
                          'Y')) THEN(DO)
/*                                                                                                */
/* Calculate the remote command DDM file name.                                                    */
/*                                                                                                */
              CHGVAR     VAR(&DDMRM6) VALUE(%SST(&SVAL9 1 10))
/*                                                                                                */
/* Calculate the remote command DDM file library name.                                            */
/*                                                                                                */
              CHGVAR     VAR(&DDMLI6) VALUE(%SST(&SVAL10 1 10))
/*                                                                                                */
             ENDDO
/*                                                                                                */
/*/COPY WNCPYSRC,SCC2477MPS                                                                       */
 
/* Allocate data area GPJRNLOCK to indicate program is active */
 
             ALCOBJ     OBJ((GPJRNLOCK *DTAARA *EXCL)) WAIT(9999)
 
LOOPER:
 
/* Determine currently attached receiver                                                          */
 
             RTVJRNE    JRN(GPJRN) TOENT(*FIRST) SEARCH(*DESCEND) +
                          RTNRCV(&CURRCV) RTNRCVLIB(&RCVLIB)
 
/* Determine size and creation time of the currently attached receiver                            */
 
             RTVOBJD    OBJ(&CURRCV) OBJTYPE(*JRNRCV) +
                          CRTDATE(&RCVDATTIM) SIZE(&RCVSIZE)
 
/* Ensure the curently attached receiver                                                          */
/* has a threshold defined.  Call program SCC002477                                               */
 
             CALL       PGM(SCC002477) PARM(&CURRCV &RCVLIB &THRESH)
 
/*                                                                                                */
/* Retrieve system values to determine whether details have                                       */
/* changed.                                                                                       */
/*                                                                                                */
             CALL       PGM(GPAOSVALR0) PARM(&RSVALRTNC +
                             'GlobalRcvSizeOption' &SVAL1 +
                             'GlobalJrnRcvThld' &SVAL2 +
                             'GlobalRmvIntJrnEnt' &SVAL3 +
                             'GlobalMinFixLenJrnE' &SVAL4 +
                             'GlobalContJrnSeqNum' &SVAL5 +
                             'GlobalRmtJrnActive' &SVAL6 +
                             'GlobalIgnTgtOnDel' &SVAL7 +
                             'GlobalMangBackUpJrn' &SVAL8 +
                             'GlobalDdmFileName' &SVAL9 +
                             'GlobalDdmFileLib' &SVAL10)
 
/* If there is an error finding any system value then end abnormally                              */
 
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))
/*                                                                                                */
             CALL       PGM(GPAOSVALR0) PARM(&RSVALRTNC +
                          'GlobalJrnChangeBasis' &SVAL11 +
                          'GlobalJrnChangeTime' &SVAL12 &SVALK13 +
                          &SVAL13 &SVALK14 &SVAL14 &SVALK15 &SVAL15 +
                          &SVALK16 &SVAL16 &SVALK17 &SVAL17 +
                          &SVALK18 &SVAL18 &SVALK19 &SVAL19 +
                          &SVALK20 &SVAL20)
 
/* If there is an error finding any system value, then end abnormally                             */
 
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))
/*                                                                                                */
/*  Determine basis for changing journal receivers.                                               */
/*                                                                                                */
             CHGVAR     VAR(&CHGBASIS) VALUE(%SST(&SVAL11 1 4))
/*                                                                                                */
/*  Determine time for changing journal receivers.                                                */
/*                                                                                                */
             CHGVAR     VAR(&CHGTIM) VALUE(%SST(&SVAL12 1 6))
/*                                                                                                */
/* If any of the first 10 system values have changed,                                             */
/*                                                                                                */
             IF         COND((&SVAL1 *NE &SVAL1SAV) *OR (&SVAL2 *NE +
                          &SVAL2SAV) *OR (&SVAL3 *NE &SVAL3SAV) *OR +
                          (&SVAL4 *NE &SVAL4SAV) *OR (&SVAL5 *NE +
                          &SVAL5SAV) *OR (&SVAL6 *NE &SVAL6SAV) *OR +
                          (&SVAL7 *NE &SVAL7SAV) *OR (&SVAL8 *NE +
                          &SVAL8SAV) *OR (&SVAL9 *NE &SVAL9SAV) *OR +
                          (&SVAL10 *NE &SVAL10SAV)) THEN(DO)
/*                                                                                                */
/* set the 'change journal' flag to 'Y'.                                                          */
/*                                                                                                */
              CHGVAR     VAR(&CHANGE) VALUE('Y')
/*                                                                                                */
             ENDDO
/*                                                                                                */
/*  Determine whether *MAXOPT1 or *MAXOPT2 are to be used.                                        */
/*                                                                                                */
             CHGVAR     VAR(&MAXOP6) VALUE(%SST(&SVAL1 1 1))
/**/                                                                                   /*AR1082949*/
/** Determine whether continuous journal sequence numbers are */                       /*AR1082949*/
/** being used. */                                                                     /*AR1082949*/
/**/                                                                                   /*AR1082949*/
             CHGVAR     VAR(&CNTSE6) VALUE(%SST(&SVAL5 1 1))                           /*AR1082949*/
/*                                                                                                */
/*  Determine journal receiver threshold.                                                         */
/*                                                                                                */
             CHGVAR     VAR(&THRES6) VALUE(%SST(&SVAL2 1 10))
/*                                                                                                */
/*  If threshold is blank on the system value file.                                               */
/*                                                                                                */
             IF         COND(&THRES6 *EQ '          ') THEN(DO)
/*                                                                                                */
/*  set the value to a default of 1.5 gigabytes,                                                  */
/*                                                                                                */
              CHGVAR     VAR(&THRES6) VALUE('0001500000')
/*                                                                                                */
/*  and update the system value.                                                                  */
/*                                                                                                */
              CHGVAR     VAR(%SST(&SVAL2 1 10)) VALUE('0001500000')
/*                                                                                                */
             ENDDO
/*                                                                                                */
/*  Calculate threshold value in KB.                                                              */
/*                                                                                                */
             CHGVAR     VAR(&THRESHOLDK) VALUE(&THRES6)
/*                                                                                                */
/*  Multiply by 1000 to give value in bytes rather than KB.                                       */
/*                                                                                                */
             CHGVAR     VAR(&THRESHOLDB) VALUE(&THRESHOLDK * 1000)
/*                                                                                                */
/*  Check whether threshold defined on the system value is too big.                               */
/*  If *MAXOPT1 or *MAXOPT2 is being used,                                                        */
/*                                                                                                */
             IF         COND((&MAXOP6 *EQ '1') *OR (&MAXOP6 *EQ +
                          '2')) THEN(DO)
/*                                                                                                */
/*  if the requested threshold is greater to or equal to 900 GB,                                  */
/*                                                                                                */
              IF         COND(&THRES6 *GE '0900000000') THEN(DO)
/*                                                                                                */
/*  set the value to a default of 10 gigabytes,                                                   */
/*                                                                                                */
               CHGVAR     VAR(&THRES6) VALUE('0010000000')
               CHGVAR     VAR(&THRESHOLDK) VALUE(10000000)
               CHGVAR     VAR(&THRESHOLDB) VALUE(10000000000)
/*                                                                                                */
/*  and update the system value.                                                                  */
/*                                                                                                */
               CHGVAR     VAR(%SST(&SVAL2 1 10)) VALUE('0010000000')
/*                                                                                                */
               CALL       PGM(GP009510) PARM('GlobalJrnRcvThld  ' +
                            &SVAL2 &SUPPUPD)
/*                                                                                                */
              ENDDO
/*                                                                                                */
             ENDDO
/*                                                                                                */
/*  if *MAXOPT1 or *MAXOPT2 are NOT being used,                                                   */
/*                                                                                                */
             ELSE       CMD(DO)
/*                                                                                                */
/*  if the requested threshold is greater than 1.5 GB,                                            */
/*                                                                                                */
              IF         COND(&THRES6 *GT '0001500000') THEN(DO)
/*                                                                                                */
/*  set the value to a default of 1.5 gigabytes,                                                  */
/*                                                                                                */
               CHGVAR     VAR(&THRES6) VALUE('0001500000')
               CHGVAR     VAR(&THRESHOLDK) VALUE(1500000)
               CHGVAR     VAR(&THRESHOLDB) VALUE(1500000000)
/*                                                                                                */
/*  and update the system value.                                                                  */
/*                                                                                                */
               CHGVAR     VAR(%SST(&SVAL2 1 10)) VALUE('0001500000')
/*                                                                                                */
               CALL       PGM(GP009510) PARM('GlobalJrnRcvThld  ' +
                            &SVAL2 &SUPPUPD)
/*                                                                                                */
              ENDDO
/*                                                                                                */
             ENDDO
/*                                                                                                */
/*  Determine whether internal journal entries are to be removed.                                 */
/*                                                                                                */
             CHGVAR     VAR(&RMVIN6) VALUE(%SST(&SVAL3 1 1))
/*                                                                                                */
/*  If value is blank on the system value file.                                                   */
/*                                                                                                */
             IF         COND(&RMVIN6 *EQ ' ') THEN(DO)
/*                                                                                                */
/*  set a default value of 'N',                                                                   */
/*                                                                                                */
              CHGVAR     VAR(&RMVIN6) VALUE('N')
/*                                                                                                */
/*  and update the system value file.                                                             */
/*                                                                                                */
              CHGVAR     VAR(%SST(&SVAL3 1 1)) VALUE('N')
              CALL       PGM(GP009510) PARM('GlobalRmvIntJrnEnt' +
                            &SVAL3 &SUPPUPD)
/*                                                                                                */
             ENDDO
/*                                                                                                */
/*  Determine whether mininal fixed length journal entries are                                    */
/*  required.  (Not recommended!!)                                                                */
/*                                                                                                */
             CHGVAR     VAR(&MINFI6) VALUE(%SST(&SVAL4 1 1))
/*                                                                                                */
/*  If value is blank on the system value file.                                                   */
/*                                                                                                */
             IF         COND(&MINFI6 *EQ ' ') THEN(DO)
/*                                                                                                */
/*  set a default value of 'N',                                                                   */
/*                                                                                                */
              CHGVAR     VAR(&MINFI6) VALUE('N')
/*                                                                                                */
/*  and update the system value.                                                                  */
/*                                                                                                */
              CHGVAR     VAR(%SST(&SVAL4 1 1)) VALUE('N')
              CALL       PGM(GP009510) PARM('GlobalMinFixLenJrnE' +
                            &SVAL4 &SUPPUPD)
/*                                                                                                */
             ENDDO
/*                                                                                                */
/* If current receiver is greater than the threshold defined in                                   */
/* the system value, set the 'change journal flag to 'Y'.                                         */
/*                                                                                                */
             IF         COND(&RCVSIZE *GT &THRESHOLDB) THEN(DO)
/*                                                                                                */
              CHGVAR     VAR(&CHANGE) VALUE('Y')
/*                                                                                                */
             ENDDO
/*                                                                                                */
/* If current receiver does not have a threshold defined,                                         */
/* set the 'change journal flag to 'Y'.                                                           */
/*                                                                                                */
             IF         COND(&THRESH *EQ 'N') THEN(DO)
/*                                                                                                */
              CHGVAR     VAR(&CHANGE) VALUE('Y')
/*                                                                                                */
             ENDDO
/*                                                                                                */
/* If journal receivers are changed on the basis of time,                                         */
/*                                                                                                */
             IF         COND(&CHGBASIS *EQ 'TIME') THEN(DO)
/*                                                                                                */
/* determine date of current journal receiver's creation.                                         */
/*                                                                                                */
              CHGVAR     VAR(&RCVDAT) VALUE(%SST(&RCVDATTIM 1 7))
/*                                                                                                */
/* Determine the current date in the same format.                                                 */
/*                                                                                                */
              CRTDTAARA  DTAARA(QTEMP/CHK) TYPE(*CHAR) LEN(1)
              RTVOBJD    OBJ(QTEMP/CHK) OBJTYPE(*DTAARA) +
                          CRTDATE(&CURDATTIM)
              DLTDTAARA  DTAARA(QTEMP/CHK)
              CHGVAR     VAR(&CURDAT) VALUE(%SST(&CURDATTIM 1 7))
              CHGVAR     VAR(&CURTIM) VALUE(%SST(&CURDATTIM 8 6))
/*                                                                                                */
/* If the date has changed,                                                                       */
/*                                                                                                */
              IF         COND(&RCVDAT *NE &CURDAT) THEN(DO)
/*                                                                                                */
/* If the current time is greater than the receiver change time system value,                     */
/*                                                                                                */
               IF         COND(&CURTIM *GT &CHGTIM) THEN(DO)
/*                                                                                                */
/* set the 'change journal flag to 'Y'.                                                           */
/*                                                                                                */
                CHGVAR     VAR(&CHANGE) VALUE('Y')
/*                                                                                                */
               ENDDO
/*                                                                                                */
              ENDDO
/*                                                                                                */
             ENDDO
/*                                                                                                */
/* If 'change journal' flag is 'Y',                                                               */
/*                                                                                                */
             IF         COND(&CHANGE *EQ 'Y') THEN(DO)
/*                                                                                                */
/** Re-set 'change journal' flag for next loop.                                                   */
/*                                                                                                */
              CHGVAR     VAR(&CHANGE) VALUE('N')
/*                                                                                                */
/** Check whether remote journaling is in use.                                                    */
/*                                                                                                */
              CHGVAR     VAR(&RMTJR6) VALUE(%SST(&SVAL6 1 1))
/*                                                                                                */
/* Determine whether to ignore target receivers when deleting.                                    */
/*                                                                                                */
              CHGVAR     VAR(&IGNTG6) VALUE(%SST(&SVAL7 1 1))
/*                                                                                                */
/** Check whether backup journal management is in use.                                            */
/*                                                                                                */
              CHGVAR     VAR(&MNGBJ6) VALUE(%SST(&SVAL8 1 1))
/*                                                                                                */
/* Calculate the remote command DDM file name.                                                    */
/*                                                                                                */
              CHGVAR     VAR(&DDMRM6) VALUE(%SST(&SVAL9 1 10))
/*                                                                                                */
/* Calculate the remote command DDM file library name.                                            */
/*                                                                                                */
              CHGVAR     VAR(&DDMLI6) VALUE(%SST(&SVAL10 1 10))
/*                                                                                                */
/*  Construct the variable for receiver size options.                                             */
/*  Insert *MAXOPT1 or *MAXOPT2, if required.                                                     */
/*                                                                                                */
              IF         COND(&MAXOP6 *EQ '2') THEN(DO)
/*                                                                                                */
               CHGVAR     VAR(&SIZOPT1) VALUE('*MAXOPT2  ')
/*                                                                                                */
              ENDDO
/*                                                                                                */
              ELSE       CMD(DO)
/*                                                                                                */
               IF         COND(&MAXOP6 *EQ '1') THEN(DO)
/*                                                                                                */
                CHGVAR     VAR(&SIZOPT1) VALUE('*MAXOPT1  ')
/*                                                                                                */
               ENDDO
/*                                                                                                */
               ELSE       CMD(DO)
/*                                                                                                */
                CHGVAR     VAR(&SIZOPT1) VALUE('          ')
/*                                                                                                */
               ENDDO
/*                                                                                                */
              ENDDO
/*                                                                                                */
/*  Insert *RMVINTENT, if required.                                                               */
/*                                                                                                */
              IF         COND(&RMVIN6 *EQ 'Y') THEN(DO)
/*                                                                                                */
               CHGVAR     VAR(&SIZOPT2) VALUE('*RMVINTENT')
/*                                                                                                */
              ENDDO
/*                                                                                                */
              ELSE       CMD(DO)
/*                                                                                                */
               CHGVAR     VAR(&SIZOPT2) VALUE('          ')
/*                                                                                                */
              ENDDO
/*                                                                                                */
/*  Insert *MINFIXLEN, if required.                                                               */
/*                                                                                                */
              IF         COND(&MINFI6 *EQ 'Y') THEN(DO)
/*                                                                                                */
               CHGVAR     VAR(&SIZOPT3) VALUE('*MINFIXLEN')
/*                                                                                                */
              ENDDO
/*                                                                                                */
              ELSE       CMD(DO)
/*                                                                                                */
               CHGVAR     VAR(&SIZOPT3) VALUE('          ')
/*                                                                                                */
              ENDDO
/*                                                                                                */
/*  If no options are required, insert '*NONE'.                                                   */
/*                                                                                                */
              IF         COND((&SIZOPT1 *EQ '          ') *AND +
                          (&SIZOPT2 *EQ '          ') *AND +
                          (&SIZOPT3 *EQ '          ')) THEN(DO)
/*                                                                                                */
               CHGVAR     VAR(&SIZOPT1) VALUE('*NONE')
/*                                                                                                */
              ENDDO
/*                                                                                                */
/* Calculate name of next receiver in chain                                                       */
/*                                                                                                */
              CHGVAR     VAR(&RCVNBRA) VALUE(%SST(&CURRCV 3 8))
              CHGVAR     VAR(&RCVNBRN) VALUE(&RCVNBRA)
              CHGVAR     VAR(&RCVNBRN) VALUE(&RCVNBRN + 1)
              CHGVAR     VAR(&RCVNBRA) VALUE(&RCVNBRN)
              CHGVAR     VAR(&NEXTRCV) VALUE('GR' *CAT &RCVNBRA)
/*                                                                                                */
/* delete any previous version of the next receiver in                                            */
/* the chain.                                                                                     */
/*                                                                                                */
/* If remote journaling is being used and if 'Ignore                                              */
/* Target Receiver' is 'Y', then delete receiver with option *IGNTGTRCV                           */
/*                                                                                                */
              IF       COND((&RMTJR6 *EQ 'Y') *AND (&IGNTG6 *EQ +
                          'Y')) THEN(DO)
/*                                                                                                */
               DLTJRNRCV  JRNRCV(&NEXTRCV) DLTOPT(*IGNTGTRCV +
                          *IGNINQMSG)
               MONMSG     MSGID(CPF0000)
/*                                                                                                */
              ENDDO
/*                                                                                                */
              ELSE       CMD(DO)
/*                                                                                                */
               DLTJRNRCV  JRNRCV(&NEXTRCV) DLTOPT(*IGNINQMSG)
               MONMSG     MSGID(CPF0000)
/*                                                                                                */
              ENDDO
/*                                                                                                */
/* If remote journaling is being used,                                                            */
/*                                                                                                */
              IF       COND(&RMTJR6 *EQ 'Y') THEN(DO)
/*                                                                                                */
/* Calculate remote command to delete the next receiver.                                          */
/*                                                                                                */
               CHGVAR     VAR(&RMTCM6) VALUE(' ')
               CHGVAR     VAR(&RMTCM6) VALUE('DLTJRNRCV ' *CAT +
                          &JLIBRMT *TCAT '/' *CAT &NEXTRCV *CAT ' +
                          DLTOPT(*IGNINQMSG)')
/*                                                                                                */
/* Execute the remote command to delete the next receiver in the remote                           */
/* journaling library on the other machine.                                                       */
/*                                                                                                */
               SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)
               MONMSG     MSGID(CPF0000 MCH0000)
/*                                                                                                */
              ENDDO
/*                                                                                                */
/* If backup journal management is being used,                                                    */
/*                                                                                                */
              IF       COND(&MNGBJ6 *EQ 'Y') THEN(DO)
/*                                                                                                */
/* Calculate remote command to delete the next receiver.                                          */
/*                                                                                                */
               CHGVAR     VAR(&RMTCM6) VALUE(' ')
               CHGVAR   VAR(&RMTCM6) VALUE('DLTJRNRCV JRNRCV(' *CAT +
                          &JLIBBKP *TCAT '/' *CAT &NEXTRCV *TCAT ') +
                          DLTOPT(*IGNINQMSG)')
/*                                                                                                */
/* Execute the remote command to delete receiver ICRCV001 in the                                  */
/* journaling library on the backup machine.                                                      */
/*                                                                                                */
               SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)
               MONMSG     MSGID(CPF0000 MCH0000)
/*                                                                                                */
              ENDDO
/*                                                                                                */
/* If the receiver does not have a threshold, or, if the system values                            */
/* have changed, create a new receiver with a threshold                                           */
/* as defined in the system values.                                                               */
/*                                                                                                */
/** If continuous journal sequence numbers are being used, */                          /*AR1082949*/
/**/                                                                                   /*AR1082949*/
              IF        COND(&CNTSE6 *EQ 'Y') THEN(DO)                                 /*AR1082949*/
/**/                                                                                   /*AR1082949*/
/** set the sequence option to '*CONT' for continuous. */                              /*AR1082949*/
/**/                                                                                   /*AR1082949*/
                CHGVAR   VAR(&SEQOPT) VALUE('*CONT ')                                  /*AR1082949*/
/**/                                                                                   /*AR1082949*/
/** Retrieve current journal receiver and sequence number. */                          /*AR1082949*/
/**/                                                                                   /*AR1082949*/
                RTVJRNE  JRN(GPJRN) FROMENT(*LAST) RTNSEQNBR(&JNSEQ)                   /*AR1082949*/
/**/                                                                                   /*AR1082949*/
/** If journal size options *MAXOPT1 or *MAXOPT2 are being used, */                    /*AR1082949*/
/**/                                                                                   /*AR1082949*/
                IF        COND((&MAXOP6 *EQ '1') *OR (&MAXOP6 *EQ +
                             '2')) THEN(DO)                                            /*AR1082949*/
/**/                                                                                   /*AR1082949*/
/** If sequence number is greater than 9000000000, */                                  /*AR1082949*/
/**/                                                                                   /*AR1082949*/
                  IF        COND(&JNSEQ *GT 9000000000) THEN(DO)                       /*AR1082949*/
/**/                                                                                   /*AR1082949*/
/** set the sequence option to '*RESET' to reset the sequence to 1. */                 /*AR1082949*/
/**/                                                                                   /*AR1082949*/
                    CHGVAR   VAR(&SEQOPT) VALUE('*RESET')                              /*AR1082949*/
                  ENDDO                                                                /*AR1082949*/
                ENDDO                                                                  /*AR1082949*/
/**/                                                                                   /*AR1082949*/
/*  If journal size options *MAXOPT1 or *MAXOPT2 are NOT being used,                   /*AR1082949*/
/**/                                                                                   /*AR1082949*/
                ELSE      CMD(DO)                                                      /*AR1082949*/
/**/                                                                                   /*AR1082949*/
/*  If sequence number is greater than 2000000000,                                     /*AR1082949*/
/**/                                                                                   /*AR1082949*/
                  IF        COND(&JNSEQ *GT 2000000000) THEN(DO)                       /*AR1082949*/
/**/                                                                                   /*AR1082949*/
/** set the sequence option to '*RESET' to reset the sequence to 1. */                 /*AR1082949*/
/**/                                                                                   /*AR1082949*/
                    CHGVAR   VAR(&SEQOPT) VALUE('*RESET')                              /*AR1082949*/
                  ENDDO                                                                /*AR1082949*/
                ENDDO                                                                  /*AR1082949*/
              ENDDO                                                                    /*AR1082949*/
/**/                                                                                   /*AR1082949*/
/** If continuous journal sequence numbers are NOT being used, */                      /*AR1082949*/
/**/                                                                                   /*AR1082949*/
              ELSE      CMD(DO)                                                        /*AR1082949*/
/**/                                                                                   /*AR1082949*/
/** set the sequence option to '*RESET' to reset the sequence to 1.*/                  /*AR1082949*/
/**/                                                                                   /*AR1082949*/
                CHGVAR   VAR(&SEQOPT) VALUE('*RESET')                                  /*AR1082949*/
              ENDDO                                                                    /*AR1082949*/
/**/                                                                                   /*AR1082949*/
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
                          THEN(DO)
/*                                                                                                */
               CRTJRNRCV  JRNRCV(&RCVLIB/&NEXTRCV) +
                          THRESHOLD(&THRESHOLDK)
/*                                                                                                */
/* If backup journal management is being used,                                                    */
/*                                                                                                */
               IF       COND(&MNGBJ6 *EQ 'Y') THEN(DO)
/*                                                                                                */
/* Calculate remote command to create receiver.                                                   */
/*                                                                                                */
                CHGVAR     VAR(&RMTCM6) VALUE(' ')
                CHGVAR  VAR(&RMTCM6) VALUE('CRTJRNRCV JRNRCV(' *CAT +
                          &JLIBBKP *TCAT '/' *CAT &NEXTRCV *TCAT ') +
                          THRESHOLD(' *CAT &THRES6 *TCAT ')')
/*                                                                                                */
/* Execute the remote command to create receiver in the                                           */
/* journaling library on the backup machine.                                                      */
/*                                                                                                */
                SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)
                MONMSG     MSGID(CPF0000 MCH0000)
/*                                                                                                */
               ENDDO
/*                                                                                                */
/* Issue a change journal request to attach the new receiver                                      */
/*                                                                                                */
               CHGVAR     VAR(&CMD) VALUE(' ')
               IF      COND(&SIZOPT1 *NE '*NONE') THEN(DO)
/**********     CHGVAR  VAR(&CMD) VALUE('CHGJRN JRN(GPJRN) JRNRCV('   + */             /*AR1082949*/
/**********              *CAT &NEXTRCV *TCAT ') RCVSIZOPT(' *CAT + */                  /*AR1082949*/
/**********              &SIZOPT1 *BCAT &SIZOPT2 *BCAT &SIZOPT3 + */                   /*AR1082949*/
/**********              *TCAT ')') */                                                 /*AR1082949*/
                 CHGVAR   VAR(&CMD) VALUE('CHGJRN JRN(GPJRN) JRNRCV(' +
                             *CAT &NEXTRCV *TCAT ') SEQOPT(' *CAT +
                             &SEQOPT *TCAT ')  RCVSIZOPT(' *CAT +
                             &SIZOPT1 *BCAT &SIZOPT2 *BCAT &SIZOPT3 +
                             *TCAT ')')                                                /*AR1082949*/
               ENDDO
               ELSE       CMD(DO)
/**********     CHGVAR     VAR(&CMD) VALUE('CHGJRN JRN(GPJRN) JRNRCV(' + */            /*AR1082949*/
/**********              *CAT &NEXTRCV *TCAT ')') */                                   /*AR1082949*/
                 CHGVAR   VAR(&CMD) VALUE('CHGJRN JRN(GPJRN) JRNRCV(' +
                             *CAT &NEXTRCV *TCAT ') SEQOPT(' *CAT +
                             &SEQOPT *TCAT ')')                                        /*AR1082949*/
               ENDDO
               CALL       PGM(QCMDEXC) PARM(&CMD 150)
/**********    MONMSG     MSGID(CPF70F6) */                                            /*AR1082949*/
               MONMSG     MSGID(CPF0000 MCH0000)                                       /*AR1082949*/
/*                                                                                                */
/* If backup journal management is being used,                                                    */
/*                                                                                                */
               IF      COND(&MNGBJ6 *EQ 'Y') THEN(DO)
/*                                                                                                */
/* Calculate remote command to execute CHGJRN command.                                            */
/*                                                                                                */
                CHGVAR     VAR(&RMTCM6) VALUE(' ')
                IF      COND(&SIZOPT1 *NE '*NONE') THEN(DO)
/**********      CHGVAR     VAR(&RMTCM6) VALUE('CHGJRN JRN(' *CAT + */                 /*AR1082949*/
/**********              &JLIBBKP *TCAT '/GPJRN) JRNRCV(' *CAT + */                    /*AR1082949*/
/**********              &JLIBBKP *TCAT '/' *CAT &NEXTRCV *TCAT ') + */                /*AR1082949*/
/**********              RCVSIZOPT(' *CAT &SIZOPT1 *BCAT &SIZOPT2 + */                 /*AR1082949*/
/**********              *BCAT &SIZOPT3 *TCAT ')') */                                  /*AR1082949*/
                  CHGVAR    VAR(&RMTCM6) VALUE('CHGJRN JRN(' *CAT +
                               &JLIBBKP *TCAT '/GPJRN) JRNRCV(' *CAT +
                               &JLIBBKP *TCAT '/' *CAT &NEXTRCV +
                               *TCAT ') SEQOPT(' *CAT &SEQOPT +
                               *TCAT ') RCVSIZOPT(' *CAT &SIZOPT1 +
                               *BCAT &SIZOPT2 *BCAT &SIZOPT3 *TCAT ')')                /*AR1082949*/
                ENDDO
                ELSE       CMD(DO)
/**********      CHGVAR     VAR(&RMTCM6) VALUE('CHGJRN JRN(' *CAT + */                 /*AR1082949*/
/**********              &JLIBBKP *TCAT '/GPJRN) JRNRCV(' *CAT + */                    /*AR1082949*/
/**********              &JLIBBKP *TCAT '/' *CAT &NEXTRCV *TCAT ')') */                /*AR1082949*/
                  CHGVAR   VAR(&RMTCM6) VALUE('CHGJRN JRN(' *CAT +
                             &JLIBBKP *TCAT '/GPJRN) JRNRCV(' *CAT +
                             &JLIBBKP *TCAT '/' *CAT &NEXTRCV +
                             *TCAT ') SEQOPT(' *CAT &SEQOPT *TCAT ')')                 /*AR1082949*/
                ENDDO
/*                                                                                                */
/* Execute the remote command to execute the CHGJRN command on the                                */
/* backup machine.                                                                                */
/*                                                                                                */
                SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)
                MONMSG     MSGID(CPF0000 MCH0000)
/*                                                                                                */
               ENDDO
/*                                                                                                */
              ENDDO
 
/* If the receiver size exceeds threshold,                                                        */
 
              ELSE       CMD(DO)
 
/* Issue a change journal request to create a new receiver                                        */
/* and to attach the journal.                                                                     */
 
               CHGVAR     VAR(&CMD) VALUE(' ')
               IF      COND(&SIZOPT1 *NE '*NONE') THEN(DO)
/**********      CHGVAR     VAR(&CMD) VALUE('CHGJRN JRN(GPJRN) + */                    /*AR1082949*/
/**********               JRNRCV(*GEN) RCVSIZOPT(' *CAT + */                           /*AR1082949*/
/**********               &SIZOPT1 *BCAT &SIZOPT2 *BCAT &SIZOPT3 + */                  /*AR1082949*/
/**********               *TCAT ')') */                                                /*AR1082949*/
                 CHGVAR   VAR(&CMD) VALUE('CHGJRN JRN(GPJRN) +
                             JRNRCV(*GEN) SEQOPT(' *CAT &SEQOPT +
                             *TCAT ') RCVSIZOPT(' *CAT +
                             &SIZOPT1 *BCAT &SIZOPT2 *BCAT &SIZOPT3 +
                             *TCAT ')')                                                /*AR1082949*/
               ENDDO
               ELSE       CMD(DO)
/**********      CHGVAR     VAR(&CMD) VALUE('CHGJRN JRN(GPJRN) + */                    /*AR1082949*/
/**********               JRNRCV(*GEN)') */                                            /*AR1082949*/
                 CHGVAR   VAR(&CMD) VALUE('CHGJRN JRN(GPJRN) +
                             JRNRCV(*GEN) SEQOPT(' *CAT &SEQOPT +
                             *TCAT ')')                                                /*AR1082949*/
               ENDDO
               CALL       PGM(QCMDEXC) PARM(&CMD 150)
/**********    MONMSG     MSGID(CPF70F6) */                                            /*AR1082949*/
               MONMSG     MSGID(CPF0000 MCH0000)                                       /*AR1082949*/
/*                                                                                                */
/* Determine the newly attached receiver                                                          */
/*                                                                                                */
               RTVJRNE  JRN(GPJRN) TOENT(*FIRST) SEARCH(*DESCEND) +
                          RTNRCV(&CURRCV) RTNRCVLIB(&RCVLIB)
/*                                                                                                */
/* If backup journal management is being used,                                                    */
/*                                                                                                */
               IF      COND(&MNGBJ6 *EQ 'Y') THEN(DO)
/*                                                                                                */
/* Calculate remote command to execute CHGJRN command.                                            */
/*                                                                                                */
                CHGVAR     VAR(&RMTCM6) VALUE(' ')
                IF      COND(&SIZOPT1 *NE '*NONE') THEN(DO)
/**********       CHGVAR     VAR(&RMTCM6) VALUE('CHGJRN JRN(' *CAT + */                /*AR1082949*/
/**********               &JLIBBKP *TCAT '/GPJRN) JRNRCV(*GEN) + */                    /*AR1082949*/
/**********               RCVSIZOPT(' *CAT &SIZOPT1 *BCAT &SIZOPT2 + */                /*AR1082949*/
/**********               *BCAT &SIZOPT3 *TCAT ')') */                                 /*AR1082949*/
                  CHGVAR   VAR(&RMTCM6) VALUE('CHGJRN JRN(' *CAT +
                              &JLIBBKP *TCAT '/GPJRN) JRNRCV(*GEN) +
                              SEQOPT(' *CAT &SEQOPT *TCAT ') +
                              RCVSIZOPT(' *CAT &SIZOPT1 *BCAT +
                              &SIZOPT2 *BCAT &SIZOPT3 *TCAT ')')                       /*AR1082949*/
                ENDDO
                ELSE       CMD(DO)
/**********       CHGVAR     VAR(&RMTCM6) VALUE('CHGJRN JRN(' *CAT + */                /*AR1082949*/
/**********               &JLIBBKP *TCAT '/GPJRN) JRNRCV(*GEN)') */                    /*AR1082949*/
                  CHGVAR   VAR(&RMTCM6) VALUE('CHGJRN JRN(' *CAT +
                              &JLIBBKP *TCAT '/GPJRN) JRNRCV(*GEN) +
                               SEQOPT(' *CAT &SEQOPT *TCAT ')')                        /*AR1082949*/
                ENDDO
/*                                                                                                */
/* Execute the remote command to execute the CHGJRN command on the                                */
/* backup machine.                                                                                */
/*                                                                                                */
                SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)
                MONMSG     MSGID(CPF0000 MCH0000)
/*                                                                                                */
               ENDDO
/*                                                                                                */
              ENDDO
/*                                                                                                */
/* If system values changed, save the new value for later comparison.                             */
/*                                                                                                */
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
                          THEN(DO)
               CHGVAR     VAR(&SVAL1SAV) VALUE(&SVAL1)
               CHGVAR     VAR(&SVAL2SAV) VALUE(&SVAL2)
               CHGVAR     VAR(&SVAL3SAV) VALUE(&SVAL3)
               CHGVAR     VAR(&SVAL4SAV) VALUE(&SVAL4)
               CHGVAR     VAR(&SVAL5SAV) VALUE(&SVAL5)
               CHGVAR     VAR(&SVAL6SAV) VALUE(&SVAL6)
               CHGVAR     VAR(&SVAL7SAV) VALUE(&SVAL7)
               CHGVAR     VAR(&SVAL8SAV) VALUE(&SVAL8)
               CHGVAR     VAR(&SVAL9SAV) VALUE(&SVAL9)
               CHGVAR     VAR(&SVAL10SAV) VALUE(&SVAL10)
              ENDDO
/*                                                                                                */
             ENDDO
/*                                                                                                */
/* Call program SCC2478 to delete any journal receivers that are eligible for deletion.           */
/*                                                                                                */
             CALL       PGM(SCC2478)
/*                                                                                                */
/* Delay job for 10 minutes                                                                       */
/*                                                                                                */
             DLYJOB     DLY(600)
 
/* Repeat cycle of processing */
 
             GOTO       CMDLBL(LOOPER)
 
/*/COPY WNCPYSRC,SCC2477MPE                                                                       */
 
             GOTO       CMDLBL(END)
 
ABNOR:
/*/COPY WNCPYSRC,SCC2477ERR                                                                       */
 
             DMPCLPGM
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             SNDPGMMSG  MSG('Program SCC2477 ended abnormally') +
                          TOMSGQ(GPOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:
/*/COPY WNCPYSRC,SCC2477END                                                                       */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
