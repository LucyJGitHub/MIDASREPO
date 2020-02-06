/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SM Create SBS for implementation')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC1002 - Create implementation subsystem                   */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR911540           Date 13Jan12              */
/*                      CSC043             Date 18Jun10              */
/*                      BUG27793           Date 04Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BG18582            Date 10Apr08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CUP033             Date 08Jun06              */
/*                      CSM005             Date 21Sep05              */
/*                      CPK018             Date 01Jun04              */
/*                      CUP016  *CREATE    Date 01Apr03              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR911540 - Make subsystem description name unique for       */
/*                  implementation.                                  */
/*       CSC043 - MidasPlus IASP Enablement                          */
/*       BUG27793 - Enable more active jobs in subsystem.            */
/*       BG18582 - Enhancements to changing CCSIDs.                  */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CPK018 - MidasPlus packaging.  Make restartable.            */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                       */ /*CUP033*/
/**********  PGM        PARM(&BRGSVAL)  */                                         /*CUP033 CSC043*/
             PGM        PARM(&BRGSVAL &IASPYNSVAL &IASPSVAL)                              /*CSC043*/
 
             DCL        VAR(&BRGSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
             DCL        VAR(&IASPYNSVAL) TYPE(*CHAR) LEN(20)                              /*CSC043*/
             DCL        VAR(&IASPSVAL) TYPE(*CHAR) LEN(20)                                /*CCS043*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC043*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC043*/
/**COPY*UPCPYSRCG,UPGSVALDCL*                                        */ /*             */ /*CUP033*/
             DCL        VAR(&PTFUPG) TYPE(*CHAR) LEN(10)                                  /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
             DCLF       FILE(UPGSVALJ0)                                                   /*CUP033*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             CHGJOB     SWS(XXXXXX00)
 
/* Create data area /MIDASMSG in QTEMP */
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')
 
VALIDATE:                                                                                 /*CUP033*/
             RCVF                                                                         /*CUP033*/
             MONMSG     MSGID(CPF0864) EXEC(DO)                                           /*CUP033*/
                GOTO       CMDLBL(CHECK)                                                  /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
             IF         COND(&GISVAL *EQ &BRGSVAL) THEN(DO)                               /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&PTFUPG) VALUE(&GIVAL)                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
             ENDDO                                                                        /*CUP033*/
                                                                                          /*CSC043*/
             IF         COND(&GISVAL *EQ &IASPYNSVAL) THEN(DO)                            /*CSC043*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CSC043*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CSC043*/
                ENDDO                                                                     /*CSC043*/
                ELSE       CMD(DO)                                                        /*CSC043*/
                   CHGVAR     VAR(&IASP_YN) VALUE(&GIVAL)                                 /*CSC043*/
                ENDDO                                                                     /*CSC043*/
             ENDDO                                                                        /*CSC043*/
                                                                                          /*CSC043*/
             IF         COND(&GISVAL *EQ &IASPSVAL) THEN(DO)                              /*CSC043*/
                IF         COND((&GIVAL *EQ ' ') *AND (&IASP_YN *EQ +
                          'Y')) THEN(DO)                                                  /*CSC043*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CSC043*/
                ENDDO                                                                     /*CSC043*/
                ELSE       CMD(DO)                                                        /*CSC043*/
                   CHGVAR     VAR(&IASP) VALUE(&GIVAL)                                    /*CSC043*/
                ENDDO                                                                     /*CSC043*/
             ENDDO                                                                        /*CSC043*/
 
             GOTO       CMDLBL(VALIDATE)                                                  /*CUP033*/
 
/**COPY*UPCPYSRCG,UPGSVALCL1*                                        */ /*             */ /*CUP033*/
/**Check*if*all*relevant*fields*have*been*entered*in*ICD**/ /*                         */ /*CUP033*/
/**********  IF         COND(&PTFUPG *EQ ' ') THEN(DO)                                 */ /*CUP033*/
 CHECK:                                                                                   /*CUP033*/
             IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)                                 /*CUP033*/
/* Set up messages for Midas Information Screen  */
                RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)
                CALL       PGM(SCC0010) PARM('SMC1002' 'ENTER' ' ')
                GOTO       CMDLBL(END)
             ENDDO
 
/* Create message queue. */
             CHKOBJ     OBJ(&PTFUPG/SETUP) OBJTYPE(*MSGQ)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CRTMSGQ    MSGQ(&PTFUPG/SETUP) TEXT('Midas MSGQ for +
                             implementation') SIZE(10 2)
             ENDDO
 
/* Create job queue. */
             CHKOBJ     OBJ(&PTFUPG/SMJOBQ) OBJTYPE(*JOBQ)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CRTJOBQ    JOBQ(&PTFUPG/SMJOBQ) TEXT('Midas Interactive +
                             JOBQ for implementation') OPRCTL(*NO) +
                             AUTCHK(*DTAAUT) AUT(*CHANGE)
             ENDDO
 
/* Create second job queue to allow jobs to run simultaneously. */                       /*BG18582*/
             CHKOBJ     OBJ(&PTFUPG/SMJOBQNM) OBJTYPE(*JOBQ)                             /*BG18582*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                          /*BG18582*/
                CRTJOBQ    JOBQ(&PTFUPG/SMJOBQNM) TEXT('Midas +
                             Interactive JOBQ for implementation +
                             *NOMAX') OPRCTL(*NO) AUTCHK(*DTAAUT) +
                             AUT(*CHANGE)                                                /*BG18582*/
             ENDDO                                                                       /*BG18582*/
 
/* Create subsystem description. */
/**********  CHKOBJ     OBJ(&PTFUPG/SETUP) OBJTYPE(*SBSD)                            */ /*AR911540*/
             CHKOBJ     OBJ(&PTFUPG/&PTFUPG) OBJTYPE(*SBSD)                             /*AR911540*/
             MONMSG     MSGID(CPF9801) EXEC(DO)
/**********     CRTSBSD    SBSD(&PTFUPG/SETUP) POOLS((1 *BASE)) +                    */ /*BUG27793*/
/**********                  MAXJOBS(10) TEXT('Midas Subsystem for +                 */ /*BUG27793*/
/**********                  implementation')                                        */ /*BUG27793*/
/**********     CRTSBSD    SBSD(&PTFUPG/SETUP) POOLS((1 *BASE)) +                    */ /*AR911540*/
/**********                  MAXJOBS(20) TEXT('Midas Subsystem for +                 */ /*AR911540*/
/**********                  implementation')                           */ /*BUG27793*/ /*AR911540*/
                CRTSBSD    SBSD(&PTFUPG/&PTFUPG) POOLS((1 *BASE)) +
                             MAXJOBS(20) TEXT('Midas Subsystem for +
                             implementation')                                           /*AR911540*/
             ENDDO
 
/* Create output queue. */
             CHKOBJ     OBJ(&PTFUPG/SETUP) OBJTYPE(*OUTQ)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CRTOUTQ    OUTQ(&PTFUPG/SETUP) TEXT('Midas OUTQ for +
                             implementation') DSPDTA(*YES) OPRCTL(*NO) +
                             AUTCHK(*DTAAUT) AUT(*CHANGE)
             ENDDO
 
/* Create class. */
             CHKOBJ     OBJ(&PTFUPG/SMCLSI) OBJTYPE(*CLS)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CRTCLS     CLS(&PTFUPG/SMCLSI) RUNPTY(20) +
                             TIMESLICE(2000) PURGE(*YES) TEXT('Midas +
                             Interactive cls for implementation')
             ENDDO
             CHGCLS     CLS(&PTFUPG/SMCLSI) ??RUNPTY(20) +
                          ??TIMESLICE(2000)
             MONMSG     MSGID(CPF6801)
 
/* Add job queue entry. */
/**********  RMVJOBQE   SBSD(&PTFUPG/SETUP) JOBQ(SMJOBQ)                             */ /*AR911540*/
             RMVJOBQE   SBSD(&PTFUPG/&PTFUPG) JOBQ(SMJOBQ)                              /*AR911540*/
             MONMSG     MSGID(CPF0000)
/**********  ADDJOBQE   SBSD(&PTFUPG/SETUP) JOBQ(&PTFUPG/SMJOBQ) +
                          MAXACT(1) SEQNBR(10)                                       */ /*AR911540*/
             ADDJOBQE   SBSD(&PTFUPG/&PTFUPG) JOBQ(&PTFUPG/SMJOBQ) +
                          MAXACT(1) SEQNBR(10)                                          /*AR911540*/
/* Add second job queue entry. */                                                        /*BG18582*/
/**********  RMVJOBQE   SBSD(&PTFUPG/SETUP) JOBQ(SMJOBQNM)               */ /*BG18582*/ /*AR911540*/
             RMVJOBQE   SBSD(&PTFUPG/&PTFUPG) JOBQ(SMJOBQNM)                            /*AR911540*/
             MONMSG     MSGID(CPF0000)                                                   /*BG18582*/
/**********  ADDJOBQE   SBSD(&PTFUPG/SETUP) JOBQ(&PTFUPG/SMJOBQNM) +
                          MAXACT(*NOMAX) SEQNBR(20)                      */ /*BG18582*/ /*AR911540*/
             ADDJOBQE   SBSD(&PTFUPG/&PTFUPG) JOBQ(&PTFUPG/SMJOBQNM) +
                          MAXACT(*NOMAX) SEQNBR(20)                                     /*AR911540*/
/* Add routing entry. */
/**********  RMVRTGE    SBSD(&PTFUPG/SETUP) SEQNBR(99)                               */ /*AR911540*/
             RMVRTGE    SBSD(&PTFUPG/&PTFUPG) SEQNBR(99)                                /*AR911540*/
             MONMSG     MSGID(CPF0000)
/**********  ADDRTGE    SBSD(&PTFUPG/SETUP) SEQNBR(99) CMPVAL(*ANY) +
                          PGM(QSYS/QCMD) CLS(&PTFUPG/SMCLSI)                         */ /*AR911540*/
             ADDRTGE    SBSD(&PTFUPG/&PTFUPG) SEQNBR(99) +
                          CMPVAL(*ANY) PGM(QSYS/QCMD) +
                          CLS(&PTFUPG/SMCLSI)                                           /*AR911540*/
 
/* Create job description. */
             CHKOBJ     OBJ(&PTFUPG/SETUP) OBJTYPE(*JOBD)
             MONMSG     MSGID(CPF9801) EXEC(DO)
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
             CRTJOBD    JOBD(&PTFUPG/SETUP) JOBQ(&PTFUPG/SMJOBQ) +
                          OUTQ(&PTFUPG/SETUP) TEXT('Midas JOBD for +
                          implementation batch jobs') +
                          INLASPGRP(&IASP) LOG(4 0 *SECLVL) +
                          LOGCLPGM(*YES)                                                  /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
                CRTJOBD    JOBD(&PTFUPG/SETUP) JOBQ(&PTFUPG/SMJOBQ) +
                             OUTQ(&PTFUPG/SETUP) TEXT('Midas JOBD for +
                             implementation batch jobs') LOG(4 0 +
                             *SECLVL) LOGCLPGM(*YES)
             ENDDO                                                                        /*CSC043*/
             ENDDO
 
/* Add workstation entry. */
/**********  RMVWSE     SBSD(&PTFUPG/SETUP) WRKSTNTYPE(*ALL)                         */ /*AR911540*/
             RMVWSE     SBSD(&PTFUPG/&PTFUPG) WRKSTNTYPE(*ALL)                          /*AR911540*/
             MONMSG     MSGID(CPF0000)
/**********  ADDWSE     SBSD(&PTFUPG/SETUP) WRKSTNTYPE(*ALL) +
                          JOBD(&PTFUPG/SETUP) AT(*ENTER)                             */ /*AR911540*/
             ADDWSE     SBSD(&PTFUPG/&PTFUPG) WRKSTNTYPE(*ALL) +
                          JOBD(&PTFUPG/SETUP) AT(*ENTER)                                /*AR911540*/
/* Start SETUP subsystem. */
/**********  ENDSBS     SBS(SETUP) OPTION(*IMMED)                                    */ /*AR911540*/
             ENDSBS     SBS(&PTFUPG) OPTION(*IMMED)                                     /*AR911540*/
             MONMSG     MSGID(CPF1054)
             DLYJOB     DLY(10)
/**********  STRSBS     SBSD(&PTFUPG/SETUP)                                          */ /*AR911540*/
             STRSBS     SBSD(&PTFUPG/&PTFUPG)                                           /*AR911540*/
             MONMSG     MSGID(CPF1010)                                                    /*CPK018*/
             DLYJOB     DLY(10)
 
             GOTO       CMDLBL(END)
 
ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('SMC1002') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('SMC1002' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
