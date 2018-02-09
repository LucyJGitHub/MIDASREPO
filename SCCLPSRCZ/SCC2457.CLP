/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Clear save files')                           */
/********************************************************************/
/*                                                                  */
/*        Midas - System Control Module                     */
/*                                                                  */
/*          SCC2457 - CLEAR ALL SAVE FILES                          */
/*                                                                  */
/*      (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. CSC033            Date     21May07          */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      211730            Date     25Nov02          */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      100498            DATE     24SEP97          */
/*                      S01408            DATE     10MAY95          */
/*                      S01375            DATE     03APR92          */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/*       CSC033  - Include global libraries in database saves.      */
/*       211730  - Clear DBdayDTA SAVF file as well. This save file */
/*                 was created by CSC012 amendment in SCC2454 and   */
/*                 SCC2455.                                         */
/*       100498  - Clear save files only if parameter says to do so */
/*       S01408  - Addition of core hook SCC2457MP1                 */
/*       S01375  - Auto COB amendments                              */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/* File of journal receiver save file object descriptions */
/**/
             DCLF       FILE(QADSPOBJ)
             DCL        VAR(&CB_RTN_CDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CB_AUTO) TYPE(*CHAR) LEN(111)
/**/
/* BOB savfile name                */
/**/
             DCL        VAR(&BOB_SAVF) TYPE(*CHAR) LEN(5)
             DCL        VAR(&BOB_SAVF2) TYPE(*CHAR) LEN(10)                               /*211730*/
             DCL        VAR(&BOB_SAVF3) TYPE(*CHAR) LEN(10)                               /*CSC033*/
             DCL        VAR(&BOB_SAVF4) TYPE(*CHAR) LEN(10)                               /*CSC033*/
             DCL        VAR(&GLOBAL) TYPE(*CHAR) LEN(1)                                   /*CSC033*/
                                                                      /*100498*/
/* Clear savefiles *YES or *NO     */                                 /*100498*/
                                                                      /*100498*/
             DCL        VAR(&CLEAR) TYPE(*CHAR) LEN(4)                /*100498*/
/**/
/* Dual receiver indicator                   */
/**/
             DCL        VAR(&DUAL) TYPE(*CHAR) LEN(1)
/**/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
/*/COPY WNCPYSRC,SCC2457002                                          */
/**/
/* Global error trap                         */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                        EXEC(GOTO ABNORMAL)
/**/
/* Copyright statement defination at runtime */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
/**************************************************************/
/*                                                            */
/* C L E A R   J O U R N A L  R E C E I V E R                 */
/* S A V E   F I L E S                                        */
/*                                                            */
/**************************************************************/
/**/
/* Use the list of all journal receivers save files */
/* in SAV_IC_RCV                                    */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&LIB) VALUE(&SYSID *CAT 'DILIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC2457MP1                                          */
                                                                      /*S01408*/
/**/
             CHKOBJ     OBJ(SAV_IC_RCV) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(END_LOOP))
/**/
             OVRDBF     FILE(QADSPOBJ) TOFILE(SAV_IC_RCV) +
                          POSITION(*START)
 START_LOOP: RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END_LOOP))
/**/
             IF         COND(&ODOBAT *EQ 'SAVF') THEN(DO)
/**/
/* clear the save file                           */
/**/
                CLRSAVF    FILE(&LIB/&ODOBNM)
 
/**/
             ENDDO
             ELSE       CMD(DO)
                   SNDPGMMSG  MSG('File' *bcat &ODOBNM *bcat 'with +
                              attribute' *bcat &ODOBAT *bcat 'found +
                              in' *bcat &lib) TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(ABNORMAL)
             ENDDO
             GOTO       CMDLBL(START_LOOP)
END_LOOP:
/**/
/**************************************************************/
/*                                                            */
/* C L E A R   T H E   B O B  M A S T E R   L I B R A R Y     */
/* S A V E   F I L E                                          */
/*                                                            */
/**************************************************************/
/**/
/* Obtain the auto COB information via CB0602X */
/**/
             CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('*TODAY    ')
             CALL       PGM(CB0602X) PARM(&CB_RTN_CDE &CB_AUTO)
                                                                      /*100498*/
/* Determine if we have to clear the BOB savefile */                  /*100498*/
                                                                      /*100498*/
             CHGVAR     VAR(&CLEAR) VALUE(%SST(&CB_AUTO 53 4))        /*100498*/
/**/
/* Determine BOB savefile name        */
/**/
             CHGVAR     VAR(&BOB_SAVF) VALUE(%SST(&CB_AUTO 107 5))
             CHGVAR     VAR(&BOB_SAVF2) VALUE(&BOB_SAVF *CAT 'DTA')                       /*211730*/
/**/                                                                                      /*CSC033*/
/* Determine whether global libraries are saved.                                            CSC033*/
/**/                                                                                      /*CSC033*/
             RTVDTAARA  DTAARA(JNSTAT (172 1)) RTNVAR(&GLOBAL)                            /*CSC033*/
/**/                                                                                      /*CSC033*/
/* If global libraries are saved,                                                           CSC033*/
/**/                                                                                      /*CSC033*/
             IF         COND(&GLOBAL *EQ 'Y') THEN(DO)                                    /*CSC033*/
/**/                                                                                      /*CSC033*/
             CHGVAR     VAR(&BOB_SAVF3) VALUE(&BOB_SAVF)                                  /*CSC033*/
             CHGVAR     VAR(%SST(&BOB_SAVF3 1 1)) VALUE('G')                              /*CSC033*/
             CHGVAR     VAR(&BOB_SAVF4) VALUE(&BOB_SAVF3)                                 /*CSC033*/
             CHGVAR     VAR(%SST(&BOB_SAVF4 6 3)) VALUE('GTA')                            /*CSC033*/
/**/                                                                                      /*CSC033*/
             ENDDO                                                                        /*CSC033*/
/**/                                                                                      /*CSC033*/
/*/COPY WNCPYSRC,SCC2457003                                          */
/**/
/* If save file name blank then no save end program */
/**/
             IF         COND(&BOB_SAVF *EQ '     ') THEN(GOTO +
                          CMDLBL(ENDCLPGM))
                                                                      /*100498*/
             IF         COND(&CLEAR *EQ '*YES') THEN(DO)              /*100498*/
/**/
/* clear the save file                           */
/**/
             CLRSAVF    FILE(&LIB/&BOB_SAVF)
/*                                                                                        /*211730*/
/* Clear 'DBdayDTA' save file                                                             /*211730*/
             CLRSAVF    FILE(&LIB/&BOB_SAVF2)                                             /*211730*/
/**/                                                                                      /*CSC033*/
/* If global libraries are saved,                                                           CSC033*/
/**/                                                                                      /*CSC033*/
             IF         COND(&GLOBAL *EQ 'Y') THEN(DO)                                    /*CSC033*/
/**/                                                                                      /*CSC033*/
/* clear the global save files.                                                             CSC033*/
/**/                                                                                      /*CSC033*/
             CLRSAVF    FILE(&LIB/&BOB_SAVF3)                                             /*CSC033*/
             MONMSG     MSGID(CPF0000)                                                    /*CSC033*/
             CLRSAVF    FILE(&LIB/&BOB_SAVF4)                                             /*CSC033*/
             MONMSG     MSGID(CPF0000)                                                    /*CSC033*/
/**/                                                                                      /*CSC033*/
             ENDDO                                                                        /*CSC033*/
/*                                                                                        /*211730*/
/*/COPY WNCPYSRC,SCC2457001                                          */
/**/
             ENDDO                                                    /*100498*/
                                                                      /*100498*/
/**************************************************************/
/*                                                            */
/* F O R   D U A L   S Y S T E M S   C L E A R   T H E        */
/* J O U R N A L   L I B R A R Y   S A V E   F I L E          */
/*                                                            */
/**************************************************************/
/**/
             RTVDTAARA  DTAARA(JNSTAT (70 1)) RTNVAR(&DUAL)
             IF         COND(&DUAL *EQ 'Y') THEN(DO)
/**/
                CLRSAVF    FILE(&LIB/JNSAV)
/**/
             ENDDO
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/**/
/**************************************************************/
/*                                                            */
/* A B N O R M A L   T E R M I N A T I O N                    */
/*                                                            */
/**************************************************************/
ABNORMAL:
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CALL       PGM(SCC2450)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program SCC2457 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/**/
 ENDCLPGM:   ENDPGM
