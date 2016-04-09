/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MS Merva/2 - start communications')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - SWIFT direct link                                   */
/*                                                                   */
/*       MSC6001 - Start Merva/2 communications                      */
/*                                                                   */
/*       Written for S01431 - Midas to Merva/2 interface             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC023             Date 30Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 06Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      110242             Date 07Nov96              */
/*                      CSW095             DATE 07APR95              */
/*                      S01408             DATE 05MAY95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*     CPK014 - Release 4 packaging.  Move data queues from XLIB to  */
/*               DPLIB.                                              */
/*            - Submit jobs with user *JOBD                          */
/*     110242 - Change defaults for SBMJOB cmd to take *JOBD         */
/*     CSW095 - S.W.I.F.T. 1995 Message Changes.                     */
/*              Increase DTQB from 1019 to 1021.                     */
/*     S01408 - Addition of core hook MSC6001MP1                     */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(SDMGMEPD)
 
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERR)
 
/* Check whether comms program already active by allocating MS6010  */
             ALCOBJ     OBJ((MS6010 *DTAARA *EXCL)) WAIT(1)
             MONMSG     MSGID(CPF0000) EXEC(DO)
 
/* If it is, send message and terminate                             */
             CHGVAR     VAR(&MESSAGE) VALUE('Midas to Merva/2 +
                          communications already active')
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
             CALL       PGM(SCC0010) PARM('MSC6001' 'ENTER' ' ')
             GOTO       CMDLBL(END)
             ENDDO
 
/* otherwise, deallocate data area                                  */
             DLCOBJ     OBJ((MS6010 *DTAARA *EXCL))
 
/* Delete and re-create all data queues, to ensure no duplicates    */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&XLIB) VALUE(&PREFIX *CAT 'XLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,MSC6001MP1                                          */
                                                                      /*S01408*/
/************DLTDTAQ    DTAQ(MSDTQA)                                                      /*CPK014*/
/************CRTDTAQ    DTAQ(&XLIB/MSDTQA) MAXLEN(1)                                      /*CPK014*/
             CALL       PGM(QCLRDTAQ) PARM('MSDTQA' '*LIBL ')                             /*CPK014*/
 
/************DLTDTAQ    DTAQ(MSDTQB)                                                      /*CPK014*/
/*********** CRTDTAQ    DTAQ(&XLIB/MSDTQB) MAXLEN(1019)               /*CSW095*/
/************CRTDTAQ    DTAQ(&XLIB/MSDTQB) MAXLEN(1021)                        /*CSW095*/ /*CPK014*/
             CALL       PGM(QCLRDTAQ) PARM('MSDTQB' '*LIBL ')                             /*CPK014*/
 
/* Get job name for communications job termination messages         */
             RTVJOBA    JOB(&JOB)
 
/* Submit Outgoing Messages Transmission job                        */
/************SBMJOB     CMD(CALL PGM(MSC6010) PARM(&JOB)) +           /*110242*/
/*************            JOB(MID2MER) JOBD(MBATCH) JOBQ(MSJOBQ) */   /*110242*/
/************SBMJOB     CMD(CALL PGM(MSC6010) PARM(&JOB)) +                               /*CPK014*/
/************             JOB(MID2MER) JOBD(MBATCH) JOBQ(MSJOBQ) +                        /*CPK014*/
/************             RTGDTA(*JOBD) INLLIBL(*JOBD)                /*110242*/          /*CPK014*/
/************SBMJOB     CMD(CALL PGM(MSC6010) PARM(&JOB)) +                               /*CSC023*/
/************             JOB(MID2MER) JOBD(MBATCH) JOBQ(MSJOBQ) +                        /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD)             /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(MSC6010) PARM(&JOB)) +
                          JOB(MID2MER) JOBD(MBATCH) JOBQ(MSJOBQ) +
                          USER(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD) +
                          OUTQ(*JOBD)                                                     /*CSC023*/
 
/* Submit compression program                                       */
/************SBMJOB     JOB(MSC0200) JOBD(MBATCH) JOBQ(MSJOBQ) +      /*110242*/
/*************            USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +    /*110242*/
/*************            MSC0200') */                                /*110242*/
/************SBMJOB     JOB(MSC0200) JOBD(MBATCH) JOBQ(MSJOBQ) +                          /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             MSC0200') INLLIBL(*JOBD)                    /*110242*/          /*CSC023*/
             SBMJOB     JOB(MSC0200) JOBD(MBATCH) JOBQ(MSJOBQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          MSC0200') INLLIBL(*JOBD) OUTQ(*JOBD)                            /*CSC023*/
 
/* If 'Outgoing Only' flag on ICD is 'N' (No), submit incoming      */
/* message reception job                                            */
             RCVF
/************IF         COND(&ENOGON *EQ 'N') THEN(SBMJOB CMD(CALL +  /*110242*/
/*************            PGM(MSC6020) PARM(&JOB)) JOB(MER2MID) +     /*110242*/
/*************            JOBD(MBATCH) JOBQ(MSJOBQ)) */               /*110242*/
/************IF         COND(&ENOGON *EQ 'N') THEN(SBMJOB CMD(CALL +                      /*CPK014*/
/************             PGM(MSC6020) PARM(&JOB)) JOB(MER2MID) +                         /*CPK014*/
/************             JOBD(MBATCH) JOBQ(MSJOBQ) RTGDTA(*JOBD) +                       /*CPK014*/
/************             INLLIBL(*JOBD))                             /*110242*/          /*CPK014*/
/************IF         COND(&ENOGON *EQ 'N') THEN(SBMJOB CMD(CALL +                      /*CSC023*/
/************             PGM(MSC6020) PARM(&JOB)) JOB(MER2MID) +                         /*CSC023*/
/************             JOBD(MBATCH) JOBQ(MSJOBQ) USER(*JOBD) +                         /*CSC023*/
/************             RTGDTA(*JOBD) INLLIBL(*JOBD))                        /*CPK014*/ /*CSC023*/
             IF         COND(&ENOGON *EQ 'N') THEN(SBMJOB CMD(CALL +
                          PGM(MSC6020) PARM(&JOB)) JOB(MER2MID) +
                          JOBD(MBATCH) JOBQ(MSJOBQ) USER(*JOBD) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD))                       /*CPK014*/
 
             GOTO       CMDLBL(END)
 
 ERR:        SNDPGMMSG  MSG('Midas to Merva/2 communications startup +
                          ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
