/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AK SE A/c key gen. - menu')                     */
/*********************************************************************/
/*                                                                   */
/*   Midas - Account Key Generator                                   */
/*                                                                   */
/*   AKC60 - SE A/C Key Generation Menu                              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. 202112             Date 25Jul17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 131108             Date 16Mar98              */
/*                      092374             Date 07Jan97              */
/*                      092556             Date 07Jan97              */
/*                     100986             Date  16APR96              */
/*                  S01408             Date  04MAY95                */
/*                  081881             DATE  17JAN95                */
/*                  074401             DATE  08APR93                */
/*                  S10736             Date  04NOV92                */
/*                  E40669             Date  19MAY92                */
/*                  E40664             Date  12MAY92                */
/*                  S01315             Date  14FEB91                */
/*                  E22490             Date  12JUL90                */
/*                  E22116             Date  30MAY90                */
/*                  AK0008             Date  11/10/89               */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*                                                                  */
/*   202112 - File out of balance occurred in SE0370. Fix will      */
/*            ensure to update the audit file SEACKA correctly      */
/*            when moving the generated SE account keys in the      */
/*            live file SEACKD.                                     */
/*          - Applied for MD-43337                                  */
/*   131108 - Screen not redisplayed after output of U5 message      */
/*            which requires shortening                              */
/*   092374 - Forsees problem of Duplicate Keys                     */
/*   092556 - Transfer keys to template job fails due to duplicate  */
/*   100986 - Add book code to LINK file                            */
/*   S01408 - Addition of core hook AKC60MP1                        */
/*   081881 - Add Global Monitor Message Processing                 */
/*          - Call correct pgm for option 6, Maintain Template      */
/*            Account Keys                                          */
/*   074401 - Add processing for option 6 & 7                       */
/*          - Extended commenting-out asterisks (FIX E40664)        */
/*   S10736 - XSEACKD moved to DMLIB                                */
/*   E40669 - Utility changed to preserve contents of XSEACKD       */
/*            until clear option requested.                         */
/*   E40664 - Allow definition of template - CPYF to TSEACKD.       */
/*   S01315 - Upgrade to SD standards                               */
/*            Program name changed from SEC41 to AKC60.             */
/*            Names of called programs changed.                     */
/*   E22490 - As Audit is not being carried out for XSECKD, it      */
/*            is not necessary to maintain XSECKA.                  */
/*   E22116 - Help System.Recompiled over changed dspf SEC41DF      */
/*   AK0008 - Return to 1st selection screen on CMD/3 from review.  */
/*                                                                  */
/********************************************************************/
/**/
/*           PGM                                                     */
/**/
/**  For future use:                                                 */
/**  FKEY1 will be set on if F3 is pressed from this menu            */
/**  FKEY2 is passed to/from AK0060 and will be set on if F3 is      */
/**        pressed from the AK0060 screen                            */
/**/
             PGM        PARM(&FKEY1 &FKEY2)
/**/
                                                             /*S01315*/
/*           DCLF       FILE(*LIBL/SEC41DF)  */
             DCLF       FILE(*LIBL/AKC60DF)
                                                             /*S01315*/
/**/
             DCL        VAR(&OVRD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MIDAS) TYPE(*CHAR) LEN(05)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                */
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&USRID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RUNA) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FKEY1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FKEY2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FKEY3) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&FKEY4) TYPE(*CHAR) LEN(1) VALUE('0')
                                                             /*S01315*/
/************DCL        VAR(&DLIB) TYPE(*CHAR) LEN(7) VALUE('  DLIB')*/
/************DCL        VAR(&DLIB) TYPE(*CHAR) LEN(7) VALUE('  DPLIB')/*S10736*/
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7) VALUE('  DMLIB')
                                                             /*S10736*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
                                                             /*S01315*/
/************DCL********VAR(&MSG)*TYPE(*CHAR)*LEN(132)*VALUE(A/CKey*/ /*S01315*/
/*************************Generation*-*Job*cannot*be*run*at*this*+**/ /*S01315*/
/*************************time.*Other*job(s)*are*active')***********/ /*S01315*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*081881*/
                                                                      /*081881*/
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&RUNA)
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
/************CHGVAR     VAR(%SST(&DLIB 1 2)) VALUE(&SYSID)            /*S10736*/
             CHGVAR     VAR(%SST(&DMLIB 1 2)) VALUE(&SYSID)           /*S10736*/
/************RTVJOBA    JOB(&JOB) SWS(&SWS)                        */
                                                                      /*S01408*/
/*/COPY WNCPYSRC,AKC60MP1                                            */
                                                                      /*S01408*/
             RTVJOBA    JOB(&JOB) USER(&USRID) SWS(&SWS)
/**/
/* Create LDA if it does not already exist */
/**/
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT'))
/**/                                                                  /*S01315*/
/**/                                                                  /*S01315*/
/*******************************************************************/ /*S01315*/
/*                                                                 */ /*S01315*/
/*****Send*message*'AKGN'*to*msgq*MSPECIAL*to*prevent*other*jobs****/ /*S01315*/
/*****initiating*whilst*a/c*key*generation*is*in*use.*(This*will****/ /*S01315*/
/*****have*the*same*effect*as*accessing*ICD*maintenance.)***********/ /*S01315*/
/*****Check*if*other*jobs*are*currently*active*by*receiving*********/ /*S01315*/
/*****messages*from*msgq*mstatus.***********************************/ /*S01315*/
/*                                                                 */ /*S01315*/
/*******************************************************************/ /*S01315*/
/**/                                                                  /*S01315*/
/************SNDPGMMSG**MSG('AKGN**')*TOMSGQ(*LIBL/MSPECIAL)********/ /*S01315*/
/************CHGMSGQ****MSGQ(*LIBL/MSTATUS)*RESET(*YES)*************/ /*S01315*/
/************RCVMSG*****MSGQ(*LIBL/MSTATUS)*RMV(*YES)***************/ /*S01315*/
/************RCVMSG*****MSGQ(*LIBL/MSTATUS)*RMV(*NO)*MSG(&MIDAS)****/ /*S01315*/
/*******************************************************************/ /*S01315*/
/************IF*********COND(&MIDAS**NE*'*****')*THEN(DO)***********/ /*S01315*/
/************SNDPGMMSG**MSG(&MSG)*TOPGMQ(*EXT)*TOMSGQ(*LIBL/MOPERQ)*/ /*S01315*/
/************GOTO*******CMDLBL(ENDPGM)******************************/ /*S01315*/
/************ENDDO**************************************************/ /*S01315*/
/**/
             CHKOBJ     OBJ(QTEMP/CHECK) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
/************CRTDUPOBJ  OBJ(XSEACKD) FROMLIB(&DLIB) OBJTYPE(*FILE) +  /*S10736*/
/************             TOLIB(QTEMP) NEWOBJ(CHECK) DATA(*YES)       /*S10736*/
             CRTDUPOBJ  OBJ(XSEACKD) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(CHECK) DATA(*YES)       /*S10736*/
             ENDDO
/**/
                                                             /*S01315*/
/* RDSPLY:     SNDRCVF    RCDFMT(SEC41R1)  */
 RDSPLY:     SNDRCVF    RCDFMT(AKC60R1)
                                                             /*S01315*/
             CHGJOB     SWS(XXX0XXXX)
             IF         COND(&IN03 *OR &IN12) THEN(GOTO CMDLBL(ENDPGM))
             CHGVAR     VAR(&IN80) VALUE('0')
             CHGVAR     VAR(&IN81) VALUE('0')
             CHGVAR     VAR(&IN82) VALUE('0')
/**/
/*********************************************************************/
/*                                                                   */
/*  Menu option 1  -  Input generation parameters & call generation  */
/*                                                                   */
/*********************************************************************/
/**/
             IF         COND(&OPTION *EQ '1') THEN(DO)
             CPYF       FROMFILE(*LIBL/XSEACKD) TOFILE(QTEMP/CHECK) +
                          MBROPT(*REPLACE)
/**********  MONMSG     MSGID(CPF2817)  EXEC(DO)                       *E40669*/
             MONMSG     MSGID(CPF2817)                                /*E40669*/
 GENERATE:   CLRPFM     FILE(*LIBL/LINKD)
             CLRPFM     FILE(*LIBL/LINKDX1)                  /*100986*/
/**********  CLRPFM     FILE(*LIBL/XSEACKD)                            *E40669*/
             CHGJOB     SWS(XXXXXX00)
                                                             /*S01315*/
/************CALL       PGM(*LIBL/SE4000) PARM(&FKEY2)   */
             CALL       PGM(*LIBL/AK0060) PARM(&FKEY2)
                                                             /*S01315*/
/**/
/*   FOR DATABASE ERRORS RECOVER DATA FROM LDA                      */
/**/
/************IF         COND(%SWITCH(XXXXXX11)) THEN(DO)            */
/************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)           */
/************RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)           */
/************SNDPGMMSG  MSGID(MEM0001) MSGF(*LIBL/MIDAS) MSGDTA(&MEM)*/
/************             TOPGMQ(*EXT) TOMSGQ(*LIBL/MOPERQ)          */
/************GOTO       CMDLBL(ENDPGM)                               */
/************ENDDO                                                   */
/**/
/*  If F3 pressed from AK0060, exit to Module Selection */
/**/
             IF         COND(&FKEY2 *EQ '1') THEN(DO)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
/*  If AK0060 completes normally, redisplay Securities Menu */
/**/
             CHGVAR     VAR(&OPTION) VALUE(' ')
             GOTO       CMDLBL(RDSPLY)
/**/
/**********  ENDDO                                                     *E40669*/
/**/
/* Display error screen if keys already exist in temporary file    */
/**/
                                                             /*S01315*/
/**RDSPLY2:****SNDRCVF****RCDFMT(SEC41R2) */
/*RDSPLY2:****SNDRCVF****RCDFMT(AKC60R2)*                              *E40669*/
                                                             /*S01315*/
/**********  CHGVAR     VAR(&IN82) VALUE('0')                          *E40669*/
/**/
/*  If 'A' entered, clear file and generate new set of keys */
/**/
/************IF         COND(&REPLY *EQ 'A') THEN(GOTO +
/************             CMDLBL(GENERATE))                            *E40669*/
/************ELSE       CMD(GOTO CMDLBL(RDSPLY))                  */
/**/
/*  If 'B' entered, do not generate & return to menu of options */
/**/
/************IF         COND(&REPLY *EQ 'B') THEN(DO)                  *E40669*/
/************GOTO       CMDLBL(RDSPLY)                                 *E40669*/
/************ENDDO                                                     *E40669*/
/**/
/*  If neither 'A' or 'B' entered, display error message */
/**/
/************IF         COND((&REPLY *NE 'A') *OR (&REPLY *NE 'B')) +
/*************            THEN(DO)                            *E40669*/
/******CHGVAR     VAR(&MSG3) VALUE('Invalid option entered')  *E40669*/
/************CHGVAR     VAR(&IN82) VALUE('1')                 *E40669*/
/************GOTO       CMDLBL(RDSPLY2)                       *E40669*/
/************ENDDO                                            *E40669*/
             ENDDO
/**/
/*********************************************************************/
/*                                                                   */
/*  Menu option 2  -  Review/Update keys generated in this session.  */
/*                                                                   */
/*********************************************************************/
/**/
             IF         COND(&OPTION *EQ '2') THEN(DO)
             CPYF       FROMFILE(*LIBL/XSEACKD) TOFILE(QTEMP/CHECK) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) EXEC(DO)
             CHGVAR     VAR(&MSG1) VALUE('There are no keys +
                          in the workfile - use Option 1')
             CHGVAR     VAR(&IN80) VALUE('1')
             GOTO       CMDLBL(RDSPLY)
             ENDDO
/**/
/*    Clear dummy trailer and initialise it.    */
/**/
/************CLRPFM     FILE(*LIBL/XSEACKA)                             E22490*/
/************INZPFM     FILE(*LIBL/XSEACKA) TOTRCDS(1)                  E22490*/
/**/
                                                             /*S01315*/
/*****Call*SEC42*to*select*logical*view*of*keys*required.**/
/*    Call AKC61 to select logical view of keys required. */
/**/
/************CALL       PGM(*LIBL/SEC42) PARM(&OVRD)    AK0008 **/
/* SELECT:     CALL     PGM(*LIBL/SEC42) PARM(&OVRD)*/ /* AK0008 */ /*S0131 5*/
 SELECT:     CALL       PGM(*LIBL/AKC61) PARM(&OVRD)
                                                             /*S01315*/
             RTVJOBA    JOB(&JOB) SWS(&SWS)
/************IF         COND((%SST(&SWS 3 1)) *EQ '1') THEN(GOTO + */
/**/
/* If F12 pressed from selection screen, redisplay Securities menu */
/**/
             IF         COND((%SST(&SWS 4 1)) *EQ '1') THEN(GOTO +
                          CMDLBL(RDSPLY))
/**/
/* If F3 pressed from selection screen, exit to Main Menu            */
/**/
             IF         COND((%SST(&SWS 3 1)) *EQ '1') THEN(GOTO +
                          CMDLBL(ENDPGM))
/**/
             IF         COND(&OVRD *EQ 'SEKEYSXX') THEN(GOTO +
                          CMDLBL(NOOVRD))
             OVRDBF     FILE(XSEACKD) TOFILE(*LIBL/&OVRD) SHARE(*NO)
             GOTO       CMDLBL(OVRD)
 NOOVRD:     OVRDBF     FILE(XSEACKD) SHARE(*NO)
/**/                                                         /*S01315*/
/****OVRD:***CALL       PGM(*LIBL/SE4020)                          */
/*VRD:*******CALL       PGM(*LIBL/AK0062) PARM(&FKEY3 &FKEY4)      */ /*081881*/
 OVRD:                                                                /*081881*/
             CALL       PGM(*LIBL/AK0062) PARM(&FKEY3 &FKEY4 +
                          'WORKFILE')                                 /*081881*/
/**/                                                         /*S01315*/
             DLTOVR     FILE(XSEACKD)
/**/                                                         /*S01315*/
/*  If F12 pressed from AK0062, display first selection screen  */
/**/
             IF         COND(&FKEY3 *EQ '2') THEN(GOTO CMDLBL(SELECT))
/**/
/*  If F3 pressed from AK0062, return to main menu             */
/**/
             IF         COND(&FKEY3 *EQ '1') THEN(GOTO CMDLBL(ENDPGM))
/**/
/*  If F12 pressed from AK0063, display first selection screen  */
/**/
/************IF         COND(&FKEY4 *EQ '2') THEN(GOTO CMDLBL(SELECT))*/
/**/
/*  If F10 pressed from AK0063, display first selection screen  */
/**/
/************IF         COND(&FKEY4 *EQ '3') THEN(GOTO CMDLBL(SELECT))*/
/**/
/*  If F3 pressed from AK0063, return to main menu             */
/**/
             IF         COND(&FKEY4 *EQ '1') THEN(GOTO CMDLBL(ENDPGM))
                                                             /*S01315*/
/************GOTO       CMDLBL(RDSPLY)                  AK0008 **/
/************GOTO       CMDLBL(SELECT)                             */
/**/
/*  Else redisplay Securities Menu                                  */
/**/
             CHGVAR     VAR(&OPTION) VALUE(' ')
             GOTO       CMDLBL(RDSPLY)
             ENDDO
/**/
/*********************************************************************/
/*                                                                   */
/*  Menu option 3  -  Produce Input Form Print.                      */
/*                                                                   */
/*********************************************************************/
/**/
             IF         COND(&OPTION *EQ '3') THEN(DO)
             CPYF       FROMFILE(*LIBL/XSEACKD) TOFILE(QTEMP/CHECK) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) EXEC(DO)
             CHGVAR     VAR(&MSG1) VALUE('There are no keys +
                          in the workfile - use Option 1')
             CHGVAR     VAR(&IN80) VALUE('1')
             GOTO       CMDLBL(RDSPLY)
             ENDDO
                                                             /*S01315*/
/************CALL       PGM(*LIBL/SE4050)    */
             CALL       PGM(*LIBL/AK0065)
                                                             /*S01315*/
/**/
/*   FOR DATABASE ERRORS RECOVER DATA FROM LDA                      */
/**/
/************IF         COND(%SWITCH(XXXXXX11)) THEN(DO)            */
/************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)           */
/************RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)           */
/************SNDPGMMSG  MSGID(MEM0001) MSGF(*LIBL/MIDAS) MSGDTA(&MEM)*/
/************             TOPGMQ(*EXT) TOMSGQ(*LIBL/MOPERQ)          */
/************GOTO       CMDLBL(ENDPGM)                               */
/************ENDDO                                                   */
/**/
             CHGVAR     VAR(&OPTION) VALUE(' ')
             GOTO       CMDLBL(RDSPLY)
             ENDDO
/**/
/*********************************************************************/
/*                                                                   */
/*  Menu option 4  -  Transfer keys generated in this session        */
/*                    across to live files and update SEACKA.        */
/*                                                                   */
/*********************************************************************/
/**/
             IF         COND(&OPTION *EQ '4') THEN(DO)
/**/
             CPYF       FROMFILE(*LIBL/XSEACKD) TOFILE(QTEMP/CHECK) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) EXEC(DO)
             CHGVAR     VAR(&IN80) VALUE('1')
             CHGVAR     VAR(&MSG1) VALUE('There are no keys +
                          in the workfile - use Option 1')
             GOTO       CMDLBL(RDSPLY)
             ENDDO
/**/
             CHGJOB     SWS(XXXXXX00)
                                                             /*S01315*/
/************CALL       PGM(*LIBL/SE4040)    */
/**********  CALL       PGM(*LIBL/AK0064) */                          /*202112*/
                                                             /*S01315*/
/**/
/*   FOR DATABASE ERRORS RECOVER DATA FROM LDA                      */
/**/
/**********  IF         COND(%SWITCH(XXXXXXX1)) THEN(DO) */           /*202112*/
/************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)           */
/**********  RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM) */          /*202112*/
/**********  SNDPGMMSG  MSGID(MEM0001) MSGF(*LIBL/MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(*LIBL/MOPERQ) */        /*202112*/
/**********  GOTO       CMDLBL(ENDPGM) */                             /*202112*/
/**********  ENDDO */                                                 /*202112*/
/**/
             CALL AK0112                                             /*092374*/
/************CPYF       FROMFILE(*LIBL/XSEACKD) TOFILE(*LIBL/SEACKD) +
                          MBROPT(*ADD) INCREL((*IF RECI *EQ 'D')) +
                          FMTOPT(*NOCHK)                             **092374*/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(*LIBL/QCPFMSG) +
                          MSGDTA('TRANSFER FAILED - press ENTER to +
                          continue & check joblog') TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
             GOTO       CMDLBL(RDSPLY)
             ENDDO
             IF         COND(%SWITCH(XXXX1XXX)) THEN(DO)              /*092374*/
/*           SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Keys +   /*131108*/
/*                     transferred successfully to live but some +
/*                     A/C keys are double and are still in work file +
/*                     If you want to transfere again don''t forget to +
/*                     delete same keys in master file or come back at the-
/*                     the begining to clear work file') +
/*                     TOPGMQ(*EXT) MSGTYPE(*STATUS)           /*092374 131108*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Not all +
                          Keys transferred to live.  Some +
                          duplicates exist in the work file') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)             /*131108*/
             GOTO       CMDLBL(RDSPLY)                              /*131108*/
             ENDDO                                                    /*092374*/
             ELSE DO                                                  /*092374*/
/**/
             CLRPFM     FILE(*LIBL/XSEACKD)
             ENDDO                                                    /*092374*/
             CHGVAR     VAR(&OPTION) VALUE(' ')
             GOTO       CMDLBL(RDSPLY)
/**/
             ENDDO
/**/
/*********************************************************************  E40664*/
/*                                                                   *  E40664*/
/*  Menu option 5  -  Define current contents of XSEACKD as a        *  E40664*/
/*                    template by copying it to TSEACKD.             *  E40664*/
/*                                                                   *  E40664*/
/*********************************************************************  E40664*/
/**/                                                                  /*E40664*/
             IF         COND(&OPTION *EQ '5') THEN(DO)                /*E40664*/
/**/                                                                  /*E40664*/
             CPYF       FROMFILE(*LIBL/XSEACKD) TOFILE(QTEMP/CHECK) +
                          MBROPT(*REPLACE)                            /*E40664*/
             MONMSG     MSGID(CPF2817) EXEC(DO)                       /*E40664*/
             CHGVAR     VAR(&IN80) VALUE('1')                         /*E40664*/
             CHGVAR     VAR(&MSG1) VALUE('There are no keys +
                          in the workfile - use Option 1')            /*E40664*/
             GOTO       CMDLBL(RDSPLY)                                /*E40664*/
             ENDDO                                                    /*E40664*/
/**/                                                                  /*E40664*/
/*           CPYF       FROMFILE(*LIBL/XSEACKD) TOFILE(*LIBL/TSEACKD) +
                          MBROPT(*ADD) INCREL((*IF RECI *EQ 'D')) +
                          FMTOPT(*NOCHK)                     E40664     092556*/
             CHGJOB SWS(XXXX0XXX)                                     /*092556*/
             CALL AK0110                                              /*092556*/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)       /*E40664*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(*LIBL/QCPFMSG) +
                          MSGDTA('TRANSFER FAILED - check joblog') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)               /*E40664*/
             GOTO       CMDLBL(RDSPLY)                                /*E40664*/
             ENDDO                                                    /*E40664*/
/**/                                                                  /*E40664*/
/************CLRPFM     FILE(*LIBL/XSEACKD)                     E40664  092374*/
             IF         COND(%SWITCH(XXXX1XXX)) THEN(DO)              /*092374*/
/*           SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Keys +   /*131108*/
/*                     transferred successfully to live but some +
/*                     A/C keys are double and are still in work file +
/*                     If you want to transfer again don''t forget to +
/*                     delete same keys in master file or come back at the-
/*                     the begining to clear work file') +
/*                     TOPGMQ(*EXT) MSGTYPE(*STATUS)           /*092374 131108*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Not all +
                          Keys transferred to live.  Some +
                          duplicates exist in the work file') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)             /*131108*/
             GOTO       CMDLBL(RDSPLY)                              /*131108*/
             ENDDO                                                    /*092374*/
             ELSE DO                                                  /*092374*/
             CLRPFM     FILE(*LIBL/XSEACKD)                           /*092374*/
             ENDDO                                                    /*092374*/
             CHGVAR     VAR(&OPTION) VALUE(' ')                       /*E40664*/
             GOTO       CMDLBL(RDSPLY)                                /*E40664*/
/**/                                                                  /*E40664*/
             ENDDO                                                    /*E40664*/
/**/                                                                  /*E40664*/
/********************************************************************* *E40669*/
/*                                                                   * *E40669*/
/***Menu*option*6**-**Clear*Workfile                      * *E40669   /*074401*/
/** Menu option 6  -  Maintain Template Key                          * *074401*/
/*                                                                   * *E40669*/
/********************************************************************* *E40669*/
/**/                                                                  /*074401*/
             IF         COND(&OPTION *EQ '6') THEN(DO)                /*074401*/
/**/                                                                  /*074401*/
/************OVRDBF     FILE(SEACKA) TOFILE(TSEACKA)            /*074401081881*/
/************OVRDBF     FILE(SEACKD) TOFILE(TSEACKD)            /*074401081881*/
/************STRJRNPF   FILE(TSEACKA TSEACKD) JRN(ICJRN) +
/************             OMTJRNE(*OPNCLO)                      /*074401081881*/
/************CALLBF     PGM(SE0110)OPNCLO)E(TSEACKD)            /*074401081881*/
/************DLTOVR     FILE(SEACKA SEACKD)                     /*074401081881*/
/************ENDJRNPF   FILE(TSEACKA TSEACKD) JRN(ICJRN)        /*074401081881*/
/**/                                                                  /*081881*/
             CALL       PGM(AKC0062)                                  /*081881*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*081881*/
             CHGVAR     VAR(&OPTION) VALUE(' ')                       /*074401*/
             GOTO       CMDLBL(RDSPLY)                                /*074401*/
/**/                                                                  /*074401*/
             ENDDO                                                    /*074401*/
/**/                                                                  /*074401*/
/********************************************************************* *074401*/
/** Menu option 7  -  Clear work file                                * *074401*/
/*                                                                   * *074401*/
/********************************************************************* *074401*/
/**/                                                                  /*E40669*/
/*********** IF         COND(&OPTION *EQ '6') THEN(DO)     /*E40669*/ /*074401*/
             IF         COND(&OPTION *EQ '7') THEN(DO)                /*074401*/
/**/                                                                  /*E40669*/
/**/                                                                  /*E40669*/
             CLRPFM     FILE(*LIBL/XSEACKD)                           /*E40669*/
             CHGVAR     VAR(&OPTION) VALUE(' ')                       /*E40669*/
             GOTO       CMDLBL(RDSPLY)                                /*E40669*/
/**/                                                                  /*E40669*/
             ENDDO                                                    /*E40669*/
/**/                                                                  /*E40669*/
/********************************************************************* 092374*/
/*  Menu option 8  -  Clear template file                            * 092374*/
/*                                                                   * 092374*/
/********************************************************************* 092374*/
             IF         COND(&OPTION *EQ '8') THEN(DO)               /*092374*/
/**/                                                                 /*092374*/
/**/                                                                 /*092374*/
             CLRPFM     FILE(*LIBL/TSEACKD)                          /*092374*/
             CHGVAR     VAR(&OPTION) VALUE(' ')                      /*092374*/
             GOTO       CMDLBL(RDSPLY)                               /*092374*/
/**/                                                                 /*092374*/
             ENDDO                                                   /*092374*/
/*********************************************************************/
/*********                                                           * *074401*/
/***Menu*option*5**-**Exit*A/C*key*generation*menu.******************* *074401*/
/*********                                                           * *074401*/
/*********************************************************************/
/*********/
/*********IF         COND(&OPTION *EQ '5') THEN(GOTO CMDLBL(ENDPGM)) */
/*********/
/*********************************************************************/
/*                                                                   */
/*  Invalid menu option - send error message                         */
/*                                                                   */
/*********************************************************************/
/**/
/************IF         COND(&OPTION *GE '5' *OR &OPTION *LT '1') +  */
/************             THEN(DO)                                   */
/************IF*********COND(&OPTION**GE*'4'**OR*&OPTION**LT*'1')*+*** *074401*/
/************IF*********COND(&OPTION *GE '7' *OR &OPTION *LT '1')074401 092374*/
/*************************THEN(DO)*******************************074401*092374*/
             IF         COND(&OPTION *GE '8' *OR &OPTION *LT '1') +
                          THEN(DO)                                    /*092374*/
             CHGVAR     VAR(&MSG2) VALUE('Invalid option entered')
             CHGVAR     VAR(&IN81) VALUE('1')
             ENDDO
/**/
             GOTO       CMDLBL(RDSPLY)
/**/
             GOTO       CMDLBL(ENDPGM) /*081881*/
ABNOR:                                                                /*081881*/
/**/                                                                  /*081881*/
/*  DISPLAY MIDAS INFORMATION SCREEN                          */      /*081881*/
             DLTOVR     FILE(*ALL)                                    /*081881*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*081881*/
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE('Securities +
                          Trading Account Key Generator')             /*081881*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*081881*/
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE('terminated +
                          abnormally')                                /*081881*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*081881*/
             CHGDTAARA  DTAARA(MIDASMSG (451 50)) VALUE('See joblog +
                          for details')                               /*081881*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*081881*/
             CALL       PGM(SCC0010) PARM('AKC60   ' 'ENTER' ' ')     /*081881*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*081881*/
             DMPCLPGM                                                 /*081881*/
/**/                                                                  /*081881*/
 ENDPGM:     IF         COND(&IN03) THEN(CHGVAR VAR(&FKEY1) VALUE('1'))
             RCLRSC                                                   /*081881*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*081881*/
             CHGJOB     SWS(XX0XXXXX)
/*********** CLRPFM     FILE(*LIBL/XSEACKD)                   *E40669*/
/*ENDPGM:     CLRPFM     FILE(*LIBL/XSEACKD)                         */
             RCVMSG     MSGQ(*LIBL/MSPECIAL) RMV(*YES)
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
