/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MA Archive data creation control')              */
/*XBI  : OVRDBF FILE(TMPSPLF) TOFILE(FCTMPPD)                       :*/
/*********************************************************************/
/*                                                                   */
/*       Midas - Microfiche/Optical Disk Archiving Module            */
/*                                                                   */
/*       MAC0606  - Control Transfer to Tape for Archiving           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 122371             DATE 26MAY06              */
/*                      CSC023             Date 30Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      089639             Date 09JAN97              */
/*                      110242             DATE 07NOV96              */
/*                      S01408             DATE 05MAY95              */
/*                      S01408             DATE 22FEB95              */
/*                      056401             DATE 27JAN94              */
/*                      065368             DATE 12JAN94              */
/*                      S01382             DATE 28JUL92              */
/*                      E27260             DATE 11SEP91              */
/*                      S01337             DATE 16APR91              */
/*                      LN1070             DATE 07DEC90              */
/*                      LN0736             DATE 12SEP90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       122371 - Ensure CB0300 reports are included in archive.     */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       089639 - Delete individual spool entry rather than clear    */
/*                the whole output queue. Deletion will be based     */
/*                on date and time this program tries to clear the   */
/*                output queue.                                      */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
/*       S01408 - Addition of core hook MAC0606MP2                   */
/*       S01408 - Addition of core hook MAC0606MPS                   */
/*                Addition of core hook MAC0606MP1                   */
/*       056401 - Monitor for msg CPF7301, so that the program       */
/*                does not fall over when it does not find any       */
/*                members in MAOPTDPD when doing RMVM.               */
/*       065368 - PF/MAOPTDPD NOW RESIDES IN DP LIBRARY              */
/*       S01382 - OPTICAL DISK DEVELOPMENT                           */
/*       E27260 - Change 'Microfiche Archiving' to 'Midas Archiving'.*/
/*              - Remove cancel message as this is already issued by */
/*                MAC0606B.                                          */
/*       S01337 - SPLIT 'D' LIBRARY INTO 'DP' AND 'DV' LIBRARIES     */
/*       LN1070 - PROCESS CANCEL MESSAGE FROM MAC0606B               */
/*       LN0736 - CHANGES TO ERROR FLAGS AND MONITOR MESSAGES        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/* This program controls Archiving of individual reports and whole   */
/*  output queues to Microfiche and/or Optical Disk Tape files.      */
/*                                                                   */
/*********************************************************************/
 PGM    parm(&eflg)
 
 DCL        &eflg    *char   1        /* Error Flag                 */
 DCL        &machk   *char   1        /* Archiving Status           */
 DCL        &sdstat  *char 256        /* MIDAS Sys. Status - SD     */
 /*****DCL        &dlib    *char  10 value('xxDLIB    ')               *S01337*/
 DCL        &DPLIB   *char  10 value('xxDPLIB   ')                    /*S01337*/
 /***********DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10) +
 /***********             VALUE('xxDMLIB   ')           */ /*S01382*/ /*065368*/
 /**/                                                                 /*LN0736*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(100)                /*LN0736*/
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)                /*LN0736*/
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)             /*LN0736*/
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)                /*LN0736*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(128)               /*S01382*/
             DCL        VAR(&OPTC) TYPE(*CHAR) LEN(36)                /*S01382*/
             DCL        VAR(&MCFC) TYPE(*CHAR) LEN(84)                /*S01382*/
             DCL        VAR(&ODBTJQ) TYPE(*CHAR) LEN(10)              /*S01382*/
             DCL        VAR(&ODJOBD) TYPE(*CHAR) LEN(10)              /*S01382*/
             DCL        VAR(&ODHJBQ) TYPE(*CHAR) LEN(1)               /*S01382*/
             DCL        VAR(&D1BTJQ) TYPE(*CHAR) LEN(10)              /*S01382*/
             DCL        VAR(&D1JOBD) TYPE(*CHAR) LEN(10)              /*S01382*/
             DCL        VAR(&D1HJBQ) TYPE(*CHAR) LEN(1)               /*S01382*/
             DCL        VAR(&ODHOLD) TYPE(*CHAR) LEN(5)               /*S01382*/
             DCL        VAR(&MFHOLD) TYPE(*CHAR) LEN(5)               /*S01382*/
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)                /*089639*/
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)                /*089639*/
 /**/                                                                 /*LN0736*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 DCLF       file(MAARCHL3)
 
 monmsg     (RPG0000 CPF0000 MCH0000) exec(goto abnor)
 
 chgjob     sws(xxxxxx00)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 chgvar     &eflg    (' ')
 
 
/* Retrieve Archiving Status                                       */
 
   rtvdtaara  machk   rtnvar(&machk)
 
/* Set Archiving Sequance data area to zero                        */
 
   chgdtaara  maseq   value('00000')
 
/* Retrieve Midas Sustem Id                                        */
 
   rtvdtaara  sdstat  rtnvar(&sdstat)
/**chgvar     (%sst(&dlib 1 2))  (%sst(&sdstat 6 2))                   *S01337*/
   chgvar     (%sst(&dplib 1 2))  (%sst(&sdstat 6 2))                 /*S01337*/
/*********************************************************************/            /*122371 CCB020*/
/**loop:***    if        cond(%sst(&sdstat 110 5) *ne 'BEGIN') then(do) */         /*122371 CCB020*/
/**********     dlyjob     dly(60)                                 */              /*122371 CCB020*/
/**********     rtvdtaara  dtaara(sdstat) rtnvar(&sdstat)          */              /*122371 CCB020*/
/**********     goto       cmdlbl(loop)                            */              /*122371 CCB020*/
/**********  enddo                                                 */              /*122371 CCB020*/
/*******************************************************************/              /*122371 CCB020*/
/* */                                                                 /*S01408*/
/*/COPY WNCPYSRC,MAC0606MP2          */                               /*S01408*/
/* */                                                                 /*S01408*/
/**CHGVAR*****VAR(%SST(&DMLIB 1 2)) VALUE(%SST(&SDSTAT 6 2))*S01382*/ /*065368*/
 
 
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/*  If Archiving Status (&machk) is set to to 'N',                 +
   save Collation Work File & set status to 'Y' & chg MACHK dtaara */
 
 IF    (&machk *eq 'N') then+
       (DO)
       dltf    maCHDRpdz
                           monmsg  (CPF0000)
       dltf    maCDTLpdz
                           monmsg  (CPF0000)
/******cpyf    maCHDRpd  &Dlib/maCHDRpdz  crtfile(*yes)                *S01337*/
       cpyf    maCHDRpd  &Dplib/maCHDRpdz  crtfile(*yes)              /*S01337*/
                                          monmsg  (CPF0000)
/******cpyf    maCDTLpd  &Dlib/maCDTLpdz  crtfile(*yes)                *S01337*/
       cpyf    maCDTLpd  &Dplib/maCDTLpdz  crtfile(*yes)              /*S01337*/
                                          monmsg  (CPF0000)
                                                                      /*S01382*/
/*  Copy header record file data to yesterdays data file */           /*S01382*/
                                                                      /*S01382*/
       CPYF       FROMFILE(MAOHDRPD) TOFILE(MAOHRYPD) +
                    MBROPT(*REPLACE)                                  /*S01382*/
       MONMSG     MSGID(CPF0000)                                      /*S01382*/
                                                                      /*S01382*/
       CLRPFM     FILE(MAOHDRPD)                                      /*S01382*/
       MONMSG     MSGID(CPF0000)                                      /*S01382*/
                                                                      /*S01382*/
       chgvar  &machk    ('Y')
       chgdtaara MACHK   &machk
       ENDDO
 
/* ELSE, If Archiving Status (&machk) is set to 'Y',               +
   clear all Bureau Files & restore Collation Work Files           */
 
 ELSE  cmd(IF    (&machk *eq 'Y') +
       then(DO))
       clrpfm  maFICDpd
                         monmsg  (CPF0000)
/******clrpfm  maOPTDpd                                            */ /*S01382*/
/******                  monmsg  (CPF0000)                         */ /*S01382*/
       clrpfm  maCHDRpd
                         monmsg  (CPF0000)
       cpyf    maCHDRpdz  maCHDRpd   mbropt(*replace)
                         monmsg  (CPF2817)
       clrpfm  maCDTLpd
                         monmsg  (CPF0000)
       cpyf    maCDTLpdz  maCDTLpd   mbropt(*replace)
                         monmsg  (CPF2817)
       ENDDO
 
/*  Remove all members from PF/MAOPTDPD                            */ /*S01382*/
                                                                      /*S01382*/
/******RMVM       FILE(&DMLIB/MAOPTDPD) MBR(*ALL)       */ /*S01382*/ /*065368*/
       RMVM       FILE(&DPLIB/MAOPTDPD) MBR(*ALL)                     /*065368*/
             MONMSG     MSGID(CPF7301)                                /*056401*/
                                                                      /*S01382*/
/*  Create duplicate of MAOPTDPD in QTEMP                          */ /*S01382*/
                                                                      /*S01382*/
/******CRTDUPOBJ  OBJ(MAOPTDPD) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
/******             TOLIB(QTEMP) NEWOBJ(ODBUILD)        */ /*S01382*/ /*065368*/
       CRTDUPOBJ  OBJ(MAOPTDPD) FROMLIB(&DPLIB) OBJTYPE(*FILE) +
                    TOLIB(QTEMP) NEWOBJ(ODBUILD)                      /*065368*/
                                                                      /*S01382*/
/*  Add member to ODBUILD                                          */ /*S01382*/
                                                                      /*S01382*/
       ADDPFM     FILE(QTEMP/ODBUILD) MBR(TEMP)                       /*S01382*/
                                                                      /*S01382*/
/*  Call MAC0670 to add a member to MAOPTDPD for each archive ID   +
    on MAARCHL1                                                       /*S01382*/
                                                                      /*S01382*/
       CALL       PGM(MAC0670) PARM(&EFLG)                            /*S01382*/
       IF         COND(%SWITCH(XXXXXX11) *OR (&EFLG *NE ' ')) +
                    THEN(GOTO CMDLBL(ABNOR))                          /*S01382*/
                                                                      /*S01382*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* If Archiving Status (&machk) is set to to 'Y',                  +
   Archive Todays Reports and Collations due for archiving         */
 
 IF    (&machk *eq 'Y') then+
       (DO)
 
/* select Collation records to Collation Work File                 */
 
       call    MA0600
               IF    (%switch(XXXXXX11)) then(goto ABNOR)
 
/* dump Archive Output Queues for all OUTQs specified on MAARCHL3  +
   to Bureau Files                                                 */
 
READ:  rcvf    rcdfmt(MAARCHD0)
       monmsg  (CPF0864) exec(goto NEXT)
 
       clrpfm  maoutqpd
          monmsg  (CPF0000)
       ovrprtf QPRTSPLQ  hold(*YES)
       wrkoutq &EAAOTQ   output(*print)
       cpysplf QPRTSPLQ  maoutqpd  splnbr(*last)
/*********monmsg  (CPF0000)  exec(goto read)                         * *LN0736*/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&STIME)                  /*089639*/
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SDATE)                  /*089639*/
 
       call    MA0610 parm(&EAARID)
               IF    (%switch(XXXXXX11)) then(goto ABNOR)
 
       goto READ
 
NEXT:
 
/* write Today's Collation Records to Bureau Files                 */
 
       call    MA0620
               IF    (%switch(XXXXXX11)) then(goto ABNOR)
 
/**copy*Bureau*Files*to*TAPE****************************************/ /*S01382*/
 
/******call    MAC0606B                                            */ /*S01382*/
/**************IF    (%switch(XXXXXXX1)) then(goto CANCEL) /*LN1070*/ /*E27260*/
/**************IF    (%switch(XXXXXX01)) then(goto END)    /*E27260*/ /*S01382*/
/**************IF    (%switch(XXXXXX11)) then(goto ABNOR)          */ /*S01382*/
 
/**change*Archiving*Status*data*area*MACHK*to*'C'*******************/ /*S01382*/
 
/******chgdtaara  MACHK  ('C')                                     */ /*S01382*/
                                                                      /*S01382*/
/*  Check whether Optical Disk and/or Microfiche modules are       +
    switched on                                                    */ /*S01382*/
                                                                      /*S01382*/
       CALL       PGM(AOMMODR0) PARM('*DBERR ' '*FIRST ' &MMOD)       /*S01382*/
                                                                      /*S01382*/
/*  If Optical Disk is switched on, submit a job to call the       +
    Archive to Optical Disk Control program using JOBQ, JOBD       +
    and HOLD data specified on the Optical Disk ICD record         */ /*S01382*/
                                                                      /*S01382*/
       IF         COND(%SUBSTRING(&MMOD 85 1) *EQ Y) THEN(DO)         /*S01382*/
             CALL       PGM(AOOPTCR0) PARM('*DBERR ' '*FIRST ' &OPTC) /*S01382*/
                                                                      /*S01382*/
             CHGVAR     VAR(&ODJOBD) VALUE(%SUBSTRING(&OPTC 23 10))   /*S01382*/
             CHGVAR     VAR(&ODBTJQ) VALUE(%SUBSTRING(&OPTC 13 10))   /*S01382*/
             CHGVAR     VAR(&ODHJBQ) VALUE(%SUBSTRING(&OPTC 11 1))    /*S01382*/
                                                                      /*S01382*/
                                                                      /*S01382*/
             IF         COND(&ODHJBQ *EQ 'Y') THEN(CHGVAR +
                          VAR(&ODHOLD) VALUE('*YES'))                 /*S01382*/
                                                                      /*S01382*/
             IF         COND(&ODHJBQ *EQ 'N') THEN(CHGVAR +
                          VAR(&ODHOLD) VALUE('*NO'))                  /*S01382*/
                                                                      /*S01382*/
/************SBMJOB     CMD(CALL PGM(MAC0651)) JOB(OPTIC) +           /*110242*/
/*************            JOBD(&ODJOBD) JOBQ(&ODBTJQ) HOLD(&ODHOLD)*/ /*110242*/
/*************                                                 /*S01382 110242*/
/************SBMJOB     CMD(CALL PGM(MAC0651)) JOB(OPTIC) +                               /*CPK014*/
/************             JOBD(&ODJOBD) JOBQ(&ODBTJQ) RTGDTA(*JOBD) +                     /*CPK014*/
/************             INLLIBL(*JOBD) HOLD(&ODHOLD)                /*110242*/          /*CPK014*/
/************SBMJOB     CMD(CALL PGM(MAC0651)) JOB(OPTIC) +                               /*CSC023*/
/************             JOBD(&ODJOBD) JOBQ(&ODBTJQ) USER(*JOBD) +                       /*CSC023*/
/************             RTGDTA(*JOBD) INLLIBL(*JOBD) HOLD(&ODHOLD)           /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(MAC0651)) JOB(OPTIC) +
                          JOBD(&ODJOBD) JOBQ(&ODBTJQ) USER(*JOBD) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD) HOLD(&ODHOLD) +
                          OUTQ(*JOBD)                                                     /*CSC023*/
       ENDDO                                                          /*S01382*/
                                                                      /*S01382*/
/*  If Optical Disk is not switched on, update DTAARA/MACHK to 'O' */ /*S01382*/
                                                                      /*S01382*/
       ELSE       CMD(DO)                                             /*S01382*/
             CHGDTAARA  DTAARA(MACHK) VALUE('O')                      /*S01382*/
       ENDDO                                                          /*S01382*/
                                                                      /*S01382*/
/*  If Microfiche is switched on, submit a job to call the Archive +
    Microfiche to Tape Control program using JOBQ, JOBD and HOLD   +
    data specified on the Microfiche ICD record                    */ /*S01382*/
                                                                      /*S01382*/
       IF         COND(%SUBSTRING(&MMOD 54 1) *EQ Y) THEN(DO)         /*S01382*/
             CALL       PGM(AOMCFCR0) PARM('*DBERR ' '*FIRST ' &MCFC) /*S01382*/
                                                                      /*S01382*/
             CHGVAR     VAR(&D1JOBD) VALUE(%SUBSTRING(&MCFC 68 10))   /*S01382*/
             CHGVAR     VAR(&D1BTJQ) VALUE(%SUBSTRING(&MCFC 58 10))   /*S01382*/
             CHGVAR     VAR(&D1HJBQ) VALUE(%SUBSTRING(&MCFC 83 1))    /*S01382*/
                                                                      /*S01382*/
             IF         COND(&D1HJBQ *EQ 'Y') THEN(CHGVAR +
                          VAR(&MFHOLD) VALUE('*YES'))                 /*S01382*/
                                                                      /*S01382*/
             IF         COND(&D1HJBQ *EQ 'N') THEN(CHGVAR +
                          VAR(&MFHOLD) VALUE('*NO'))                  /*S01382*/
                                                                      /*S01382*/
/************SBMJOB     CMD(CALL PGM(MAC0650)) JOB(FICHE) +           /*110242*/
/*************            JOBD(&D1JOBD) JOBQ(&D1BTJQ) HOLD(&MFHOLD)*/ /*110242*/
/*************                                                 /*S01382 110242*/
/************SBMJOB     CMD(CALL PGM(MAC0650)) JOB(FICHE) +                               /*CPK014*/
/************             JOBD(&D1JOBD) JOBQ(&D1BTJQ) RTGDTA(*JOBD) +                     /*CPK014*/
/************             INLLIBL(*JOBD) HOLD(&MFHOLD)                /*110242*/          /*CPK014*/
/************SBMJOB     CMD(CALL PGM(MAC0650)) JOB(FICHE) +                               /*CSC023*/
/************             JOBD(&D1JOBD) JOBQ(&D1BTJQ) USER(*JOBD) +                       /*CSC023*/
/************             RTGDTA(*JOBD) INLLIBL(*JOBD) HOLD(&MFHOLD)           /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(MAC0650)) JOB(FICHE) +
                          JOBD(&D1JOBD) JOBQ(&D1BTJQ) USER(*JOBD) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD) HOLD(&MFHOLD) +
                          OUTQ(*JOBD)                                                     /*CSC023*/
       ENDDO                                                          /*S01382*/
                                                                      /*S01382*/
/*  If Microfiche is not switched on, update DTAARA/MACHK to 'M'   */ /*S01382*/
                                                                      /*S01382*/
       ELSE       CMD(DO)                                             /*S01382*/
             CHGDTAARA  DTAARA(MACHK) VALUE('M')                      /*S01382*/
       ENDDO                                                          /*S01382*/
                                                                      /*S01382*/
/*  Submit job to clear archived output queues using JOBQ, JOBD    +
    and HOLD data specified on Optical Disk or Microfiche ICD      +
    record                                                         */ /*S01382*/
                                                                      /*S01382*/
       IF         COND(%SUBSTRING(&MMOD 85 1) *EQ Y) THEN(DO)         /*S01382*/
/* */                                                                 /*S01408*/
/*/COPY WNCPYSRC,MAC0606MPS          */                               /*S01408*/
/* */                                                                 /*S01408*/
/************SBMJOB     CMD(CALL PGM(MAC0607)) JOB(CLROUTQ) +         /*110242*/
/*************            JOBD(&ODJOBD) JOBQ(&ODBTJQ) HOLD(&ODHOLD)   /*110242*/
/*************                                                 /*S01382 110242*/
/************SBMJOB     CMD(CALL PGM(MAC0607)) JOB(CLROUTQ) +         /*089639*/
/*************            JOBD(&ODJOBD) JOBQ(&ODBTJQ) RTGDTA(*JOBD) + /*089639*/
/*************            INLLIBL(*JOBD) HOLD(&ODHOLD)         /*110242 089639*/
/************SBMJOB     CMD(CALL PGM(MAC0607) PARM(&SDATE &STIME)) +                      /*CSC023*/
/************             JOB(CLROUTQ) JOBD(&ODJOBD) JOBQ(&ODBTJQ) +                      /*CSC023*/
/************             RTGDTA(*JOBD) INLLIBL(*JOBD) +                                  /*CSC023*/
/************             HOLD(&ODHOLD)                               /*089639*/          /*CSC023*/
             SBMJOB     CMD(CALL PGM(MAC0607) PARM(&SDATE &STIME)) +
                          JOB(CLROUTQ) JOBD(&ODJOBD) JOBQ(&ODBTJQ) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD) +
                          HOLD(&ODHOLD) OUTQ(*JOBD)                                       /*CSC023*/
/* */                                                                 /*S01408*/
/*/COPY WNCPYSRC,MAC0606MP1          */                               /*S01408*/
/* */                                                                 /*S01408*/
       ENDDO                                                          /*S01382*/
       ELSE       CMD(DO)                                             /*S01382*/
/************SBMJOB     CMD(CALL PGM(MAC0607)) JOB(CLROUTQ) +         /*110242*/
/*************            JOBD(&D1JOBD) JOBQ(&D1BTJQ) HOLD(&MFHOLD)   /*110242*/
/*************                                                 /*S01382 110242*/
/************SBMJOB     CMD(CALL PGM(MAC0607)) JOB(CLROUTQ) +         /*089639*/
/*************            JOBD(&D1JOBD) JOBQ(&D1BTJQ) RTGDTA(*JOBD) + /*089639*/
/*************            INLLIBL(*JOBD) HOLD(&MFHOLD)         /*110242 089639*/
/************SBMJOB     CMD(CALL PGM(MAC0607) PARM(&SDATE &STIME)) +                      /*CSC023*/
/************             JOB(CLROUTQ) JOBD(&D1JOBD) JOBQ(&D1BTJQ) +                      /*CSC023*/
/************             RTGDTA(*JOBD) INLLIBL(*JOBD) +                                  /*CSC023*/
/************             HOLD(&MFHOLD)                               /*089639*/          /*CSC023*/
             SBMJOB     CMD(CALL PGM(MAC0607) PARM(&SDATE &STIME)) +
                          JOB(CLROUTQ) JOBD(&D1JOBD) JOBQ(&D1BTJQ) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD) +
                          HOLD(&MFHOLD) OUTQ(*JOBD)                                       /*CSC023*/
       ENDDO                                                          /*S01382*/
 
/* End of Today's Archiving                                        */
 
       ENDDO
 
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
 
 goto END
 
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
 
/**IF*JOB*CANCELLED*FROM*TAPE*SAVE*IN*MAC0606B**/          /*LN1070*/ /*E27260*/
/**BY*USER*SEND*MESSAGE*AND*END*PROGRAM**/                 /*LN1070*/ /*E27260*/
/**/                                                                  /*LN1070*/
/*CANCEL:****CHGJOB     SWS(XXXXXXX1)                      /*LN1070*/ /*E27260*/
/************SNDMSG     MSG('Copy archive to tape job ended by +
/************             user.') TOMSGQ(MOPERQ)           /*LN1070*/ /*E27260*/
/************GOTO       CMDLBL(END)                        /*LN1070*/ /*E27260*/
/**/                                                                  /*LN1070*/
 ABNOR:    CHGJOB    sws(xxxxxx11)
/*******monmsg    (RPG0000 CPF0000 MCH0000)                          * *LN0736*/
/**********CHGVAR    &eflg  ('Y')                                    * *LN0736*/
/**********monmsg    (RPG0000 CPF0000 MCH0000)                       * *LN0736*/
/**********   SNDMSG    MSG('M/fiche Archiving Control program +     * *LN0736*/
/**********             ended abnormally')  TOMSGQ(MOPERQ)           * *LN0736*/
/**********   monmsg    (RPG0000 CPF0000 MCH0000)                    * *LN0736*/
             CHGVAR     VAR(&EFLG) VALUE('Y')                         /*LN0736*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSG) MSGID(&MSGID) +
                          MSGF(&MSGF) MSGFLIB(&MSGFLIB)               /*LN0736*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ)    /*LN0736*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
/************SNDPGMMSG  MSG('MAC0606 Control Transfer to Tape for +
/************             Microfiche Archiving terminated +
/************             abnormally.  See previous messages for +
/************             further information.') TOPGMQ(*EXT) +
/************             TOMSGQ(MOPERQ)                   /*LN0736*/ /*E27260*/
             SNDPGMMSG  MSG('MAC0606 Control Transfer to Tape for +
                          Midas Archiving terminated +
                          abnormally.  See previous messages for +
                          further information.') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)                              /*E27260*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
 
END:    ENDPGM
