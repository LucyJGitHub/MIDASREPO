/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB Submit COB monitor')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC0511 - SUBMIT MONITOR                                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. AR1096378          Date 20Mar13              */
/*       Prev Amend No. CCB021             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSC023             Date 29Jan04              */
/*                      CPK014             Date 14Nov01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      196795             Date 13Aug01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      110242             DATE 07NOV96              */
/*                      099150             DATE 02FEB96              */
/*                      098266             DATE 15JAN96              */
/*                      091688             DATE 10AUG95              */
/*                      S01408             Date 07AUG95              */
/*                      S01420 *Create     DATE 15MAR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR1096378 - NWDC issues encountered during link testing.    */
/*       CCB021 - COB Restructure - Non Working Day COB              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       196795 - Use DTAARA CBRECV instead of DTAQ MAINDTQ to avoid */
/*                object lock at V5R1M0.                             */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
/*       099150 - Change routing entry for monitor submit.           */
/*       098266 - Batch monitor hangs due to CBCMONB being submitted */
/*                with run priority (50)                             */
/*       091688 - Rename the CBCMONB job to COBMONITOR for ease      */
/*                of identification.                                 */
/*       S01408 - Hooks moved to WNCPYSRC from CBCPYSRC:             */
/*                - CBC0511INT                                       */
/*                - CBC0511MPS                                       */
/*                - CBC0511MPE                                       */
/*                - CBC0511ERR                                       */
/*                - CBC0511END                                       */
/*       S01420 - CoB Enhancements (Batch Monitor).                  */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,CBC0511INT                                          */
 
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CONT) TYPE(*DEC) LEN(1 0) VALUE(0)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000 CPI0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)                                                  /*AR1096378*/
                                                                                       /*AR1096378*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
 
             CHGVAR     VAR(&LIB) VALUE(&PREFIX *TCAT 'XLIB')
 
/*/COPY WNCPYSRC,CBC0511MPS                                          */
 
/* Try to allocate MONCHK                                          */
/* If MONCHK already allocated then Batch Monitor should be active */
/* and transfer control to Monitor Display                         */
 
             ALCOBJ     OBJ((MONCHK *DTAARA *EXCL)) WAIT(5)
             MONMSG     MSGID(CPF1002) EXEC(DO)
                TFRCTL     PGM(CBCMOND)
             ENDDO
 
/* If MONCHK not allocated by another job then submit batch monitor */
 
             DLCOBJ     OBJ((MONCHK *DTAARA *EXCL))
             GOTO       CMDLBL(SUBMIT)
 
MONACT:      ALCOBJ     OBJ((MONCHK *DTAARA *EXCL)) WAIT(5)
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(PASSMON))
 
             DLCOBJ     OBJ((MONCHK *DTAARA *EXCL))
 
/* Submit controlling monitor */
 
/*UBMIT:*****SBMJOB     CMD(CALL PGM(CBCMONB)) JOB(CBCMONB) +         /*091688*/
/************             JOBD(MEODD) RTGDTA(*JOBD)                   /*091688*/
/*UBMIT:*****SBMJOB     CMD(CALL PGM(CBCMONB)) JOB(COBMONITOR) +        098266*/
/************             JOBD(MEODD) RTGDTA(*JOBD)            /*091688*098266*/
/*SUBMIT:*** SBMJOB     CMD(CALL PGM(CBCMONB)) JOB(COBMONITOR) +
/***********              JOBD(MEODD) RTGDTA(QCMD)             /*098266*099150*/
/*********** SUBMIT:     SBMJOB     JOB(COBMONITOR) JOBD(MEODD) +
/*************            RTGDTA(MULTILANGUAGE) RQSDTA('CALL +        /*110242*/
/*************            PGM(MLC0000) PARM(''SCC0107'' ''CBCMONB'' + /*110242*/
/*************       '' '' '' '' '' '' '' '')') MSGQ(*NONE)/*099150*/ /*110242*/
                                                                      /*110242*/
 SUBMIT:                                                              /*110242*/
/************SBMJOB     JOB(COBMONITOR) JOBD(MEODD) +                                     /*CPK014*/
/************             RTGDTA(MULTILANGUAGE) RQSDTA('CALL +                            /*CPK014*/
/************             PGM(MLC0000) PARM(''SCC0107'' ''CBCMONB'' +                     /*CPK014*/
/************             '' '' '' '' '' '' '' '')') INLLIBL(*JOBD) +                     /*CPK014*/
/************             MSGQ(*NONE)                                 /*110242*/          /*CPK014*/
/************SBMJOB     JOB(COBMONITOR) JOBD(MEODD) USER(*JOBD) +                         /*CSC023*/
/************             RTGDTA(MULTILANGUAGE) RQSDTA('CALL +                            /*CSC023*/
/************             PGM(MLC0000) PARM(''SCC0107'' ''CBCMONB'' +                     /*CSC023*/
/************             '' '' '' '' '' '' '' '')') INLLIBL(*JOBD) +                     /*CSC023*/
/************             MSGQ(*NONE)                                          /*CPK014*/ /*CSC023*/
             SBMJOB     JOB(COBMONITOR) JOBD(MEODD) USER(*JOBD) +
                          RTGDTA(MULTILANGUAGE) RQSDTA('CALL +
                          PGM(MLC0000) PARM(''SCC0107'' ''CBCMONB'' +
                          '' '' '' '' '' '' '' '')') INLLIBL(*JOBD) +
                          MSGQ(*NONE) OUTQ(*JOBD)                                         /*CSC023*/
             DLYJOB     DLY(3)
 
             CHGVAR     VAR(&CONT) VALUE(&CONT + 1)
 
             IF         COND(&CONT *LE 3) THEN(GOTO CMDLBL(MONACT))
PASSMON:
 
/* Reset last message data area */
 
             CHGDTAARA  DTAARA(CBLMSG (1 40)) VALUE(' ')
             CHGDTAARA  DTAARA(CBLMSG (41 2)) VALUE('01')
 
/* Reset file */
 
             CLRPFM     FILE(CBUSERPD)
             MONMSG     MSGID(CPF0000)
 
/* Reset data queues */
 
/**********  DLTDTAQ    DTAQ(DTQ*)      */                                                /*CCB021*/
/**********  MONMSG     MSGID(CPF0000)  */                                                /*CCB021*/
 
/************CHKOBJ     OBJ(MAINDTQ) OBJTYPE(*DTAQ)                                       /*196795*/
/************MONMSG     MSGID(CPF9801) EXEC(CRTDTAQ +                                     /*196795*/
/************             DTAQ(&LIB/MAINDTQ) MAXLEN(1024) +                               /*196795*/
/************             SEQ(*KEYED) KEYLEN(10))                                         /*196795*/
/************MONMSG     MSGID(CPF9801) EXEC(CRTDTAQ +                                     /*196795*/
/************             DTAQ(&LIB/MAINDTQ) MAXLEN(1024))                                /*196795*/
 
/*/COPY WNCPYSRC,CBC0511MPE                                          */
 
             GOTO       CMDLBL(ENDP)
 
 ABNOR:
/*/COPY WNCPYSRC,CBC0511ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
             SNDMSG     MSG('Unable to submit monitor') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
 
ENDP:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,CBC0511END                                          */
 
 ENDPGM:     ENDPGM
