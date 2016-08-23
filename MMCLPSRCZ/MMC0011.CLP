/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MM Menu option control program')                */
/*********************************************************************/
/*                                                                   */
/*       Midas   - MM Module                                         */
/*                                                                   */
/*       MMC0011 - MM MENU OPTION CONTROL                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CSF011A            Date 28Nov11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. 244860             Date 15Feb07              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CSW208             Date 15Apr08              */
/*                      246914             Date 12Apr07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      240659             Date 21Aug06              */
/*                      CDL038             Date 10May05              */
/*                      BUG4745            Date 31Jan05              */
/*                      BUG3128            Date 02Jul04              */
/*                      CRE020             Date 20Jan04              */
/*                      CSC023             Date 30Jan04              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      208051             Date 07Nov02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      204803             Date 17Apr02              */
/*                      201230             Date 21Jan02              */
/*                      195484             Date 13Dec01              */
/*                      CAP067             Date 24Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      180276             Date 20Jun00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CSE006             Date 07Apr99              */
/*                      CAP052             Date 25Nov99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAP003             Date 02Mar98              */
/*                      CAP002  *CREATE    Date 02Mar98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSF011A - CCR015: Display Order in Confirmation Pages       */
/*                 (Recompile)                                       */
/*       244860 - ERZ135 changes missing.                            */
/*       CSW208 - SWIFT 2008 Changes                                 */
/*       246914 - Applied fix 240276.                                */
/*       240276 - Repo Rollover show only Non-Repo Deals.  Select    */
/*                Non-Repo or Repo deals depending on which Rollover */
/*                Maintenance option was taken.  Applied 238314.     */
/*              - Include matured deals in browse screen.  Display   */
/*                repo deals only on toggle screen.  Applied fixes   */
/*                230667 and 230668 respectively.                    */
/*       240659 - Create data area REPO for Repo repair function     */
/*                as part of fix for repair of Repo deletions.       */
/*       CDL038 - Extended Deal Sub Type                             */
/*       BUG4745 - Error in using optin M in Repo Margin Calls       */
/*       BUG3128 - Deal entered through Repo Maintenance does not    */
/*                 show in file CGUXMLPD.  Add condition to check    */
/*                 for module MMREPOSIN before Retail Advices are    */
/*                 printed.                                          */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       208051 - Confirmations and pay receives not generated       */
/*                from all options using this input.                 */
/*       204803 - Add override to files to call SE0043.              */
/*       201230 - Add override to file DPTMVDZ3 to file DPTMVDY2,    */
/*                this is essential for program SE1807 which is      */
/*                being called from within MMRPDLSFL.                */
/*       195484 - Unable to generate confirmation messages from      */
/*                range authorisation.                               */
/*       CAP067 - Repurchase Agreements API.                         */
/*       180276 - Extend 103997 to this program.                     */
/*                Change of DLSTAT position 6 ='Y' is now done       */
/*                at the start of DLC0210A to prevent non-submission */
/*                of pay/receive job.                                */
/*       CSE006 - Repurchase Agreement Enhancements                  */
/*       CAP052 - Deal Range Authorisation (By Front Office ID)      */
/*       CAP003 - Conversion of SE inputs into modular structure to  */
/*                use as APIs - Phase 2.                             */
/*       CAP002 - Conversion of MM inputs into modular structure to  */
/*                use as APIs.                                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PROG)
 
             DCL        VAR(&PROG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10) /* +
                          Return code for call to ZAGETACTGP */
             DCL        VAR(&ACTGRP) TYPE(*CHAR) LEN(10) /* The +
                          activation group that the called program +
                          runs in */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CSE006*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CSE006*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CSE006*/
             DCL        VAR(&CSE006) TYPE(*CHAR) LEN(1)               /*CSE006*/
             DCL        VAR(&CAP067) TYPE(*CHAR) LEN(1)                                   /*CAP067*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1)                                   /*CRE020*/
             DCL        VAR(&PMOD) TYPE(*CHAR) LEN(10)                                    /*CRE020*/
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(50)                                    /*CRE020*/
             DCL        VAR(&MOD) TYPE(*CHAR) LEN(128)                /*CSE006*/
/*/COPY WNCPYSRC,MMC0011001                                          */
 
             DCLF       FILE(SDMGMEPD)
 
/* Monitor for error messages not trapped in the rest of the */
/* program. If they occur reclaim resources and exit.        */
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(ERR))
             GOTO       CMDLBL(RUN)
ERR:
/*/COPY WNCPYSRC,MMC0011004                                          */
             RCLACTGRP  ACTGRP(*ELIGIBLE)
/*********** RCLRSC  *********************/                                               /*CDL038*/
 
             RETURN
 
RUN:
 
/*  RESET JOB SWITCHES */
             CHGJOB     SWS(XXXXXX00)
 
/*                                                        */          /*CSE006*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSE006*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSE006*/
             CHGVAR     VAR(&SARD) VALUE('CSE006')                    /*CSE006*/
             CHGVAR     VAR(&CSE006) VALUE('N')                       /*CSE006*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)         /*CSE006*/
/*                                                        */          /*CSE006*/
/*       Feature found if return code is blank            */          /*CSE006*/
/*                                                        */          /*CSE006*/
             IF COND((&RTCD) *EQ '       ') THEN(DO)                  /*CSE006*/
             CHGVAR     VAR(&CSE006) VALUE('Y')                       /*CSE006*/
             ENDDO                                                    /*CSE006*/
 
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CAP067*/
             CHGVAR     VAR(&SARD) VALUE('CAP067')                                        /*CAP067*/
             CHGVAR     VAR(&CAP067) VALUE('N')                                           /*CAP067*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)                             /*CAP067*/
/*                                                        */                              /*CAP067*/
/*       Feature found if return code is blank            */                              /*CAP067*/
/*                                                        */                              /*CAP067*/
             IF COND((&RTCD) *EQ '       ') THEN(DO)                                      /*CAP067*/
             CHGVAR     VAR(&CAP067) VALUE('Y')                                           /*CAP067*/
             ENDDO                                                                        /*CAP067*/
/*/COPY WNCPYSRC,MMC0011005                                          */
                                                                                          /*CAP067*/
/* Check if CRE020 is enabled. */                                                         /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CRE020*/
             CHGVAR     VAR(&SARD) VALUE('CRE020')                                        /*CRE020*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CRE020*/
             CHGVAR     VAR(&CRE020) VALUE('N')                                           /*CRE020*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)                             /*CRE020*/
                                                                                          /*CRE020*/
             IF COND(&RTCD *EQ '       ') THEN(DO)                                        /*CRE020*/
             CHGVAR     VAR(&CRE020) VALUE('Y')                                           /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&RTCD *NE '*NRF   ' *AND +
                             &RTCD *NE '       ') THEN(GOTO CMDLBL(ERR))                  /*CRE020*/
                                                                                          /*CRE020*/
/************IF         COND(&PROG *EQ 'MMDEALRAT') THEN(DO)********/ /*CAP052*/
             IF         COND(&PROG *EQ 'MMDEALRAT' *OR +
                             &PROG *EQ 'MMPBDLRAT') THEN(DO)          /*CAP052*/
             OVRDBF     FILE(MMDEALL0) SHARE(*NO)
             OVRDBF     FILE(MMDEALL2) SHARE(*NO)                     /*CAP052*/
             OVRDBF     FILE(MMCMPLLL) SHARE(*NO)
             OVRDBF     FILE(MMCARDLL) SHARE(*NO)
             OVRDBF     FILE(MMDEAULL) SHARE(*NO)                     /*CAP003*/
             OVRDBF     FILE(MMDELULL) SHARE(*NO)                     /*CAP003*/
             ENDDO
/*/COPY WNCPYSRC,MMC0011002                                          */
                                                                      /*CSE006*/
             IF         COND((&CSE006) *EQ 'Y') THEN(DO)              /*CSE006*/
/**/                                                                  /*CSE006*/
             CALL       PGM(AOMMODR0) PARM('*MSG  ' '*FIRST' &MOD)    /*CSE006*/
/**/                                                                  /*CSE006*/
/**  If Dealing module is not present then end program */             /*CSE006*/
/**/                                                                  /*CSE006*/
             IF         COND(%SST(&MOD 48 1) *EQ 'N') THEN(DO)
/*/COPY WNCPYSRC,MMC0011006                                          */
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Option +
                          is not available') TOMSGQ(MOPERQ)           /*CSE006*/
                MONMSG     MSGID(CPF0000 MCH0000)                     /*CSE006*/
                GOTO       CMDLBL(END)                                /*CSE006*/
             ENDDO                                                    /*CSE006*/
/**/                                                                  /*CSE006*/
/**  If Securities module is not presentthen end program */           /*CSE006*/
/**/                                                                  /*CSE006*/
             IF         COND(%SST(&MOD 31 1) *EQ 'N') THEN(DO)
/*/COPY WNCPYSRC,MMC0011007                                          */
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Option +
                          is not available') TOMSGQ(MOPERQ)           /*CSE006*/
                MONMSG     MSGID(CPF0000 MCH0000)                     /*CSE006*/
                GOTO       CMDLBL(END)                                /*CSE006*/
             ENDDO                                                    /*CSE006*/
/**/                                                                  /*CSE006*/
             IF         COND(&PROG *EQ 'MMLDNISIN') THEN(DO)          /*CSE006*/
             OVRDBF     FILE(MMCMPLLL) TOFILE(MMCMRPL1)               /*CSE006*/
             OVRDBF     FILE(MMCARDLL) TOFILE(MMCARPL1)               /*CSE006*/
             OVRDBF     FILE(MMDEALLL) TOFILE(MMDEALL3)               /*CSE006*/
             ENDDO                                                    /*CSE006*/
             IF         COND(&PROG *EQ 'MMREPOSIN') THEN(DO)          /*CSE006*/
             OVRDBF     FILE(MMCMPLLL) TOFILE(MMCMRPLL)               /*CSE006*/
/**********  OVRDBF     FILE(MMCARDLL) TOFILE(MMCARPL2) */                     /*CSE006*/ /*240276*/
             OVRDBF     FILE(MMCARDLL) TOFILE(MMCARPL3)                                   /*240276*/
/**********  OVRDBF     FILE(MMDEALLL) TOFILE(MMDEALL4) */                     /*CSE006*/ /*240276*/
             OVRDBF     FILE(MMDEALL0) TOFILE(MMDEALL4)                                   /*240276*/
             OVRDBF     FILE(DPTMVDZ3) TOFILE(DPTMVDY2) SHARE(*NO)                        /*201230*/
             OVRDBF     FILE(SECTYZ1)  TOFILE(SECTY) SHARE(*NO)                           /*204803*/
             OVRDBF     FILE(SECTYZ2)  TOFILE(SECTY) SHARE(*NO)                           /*204803*/
             OVRDBF     FILE(SECTYZ3)  TOFILE(SECTY) SHARE(*NO)                           /*204803*/
             OVRDBF     FILE(TRADSX1)  TOFILE(TRADS) SHARE(*NO)                           /*204803*/
             OVRDBF     FILE(DPMVX)    TOFILE(DPMV)  SHARE(*NO)                           /*204803*/
             OVRDBF     FILE(SECTYX)   TOFILE(SECTY) SHARE(*NO)                           /*204803*/
             ENDDO                                                    /*CSE006*/
             IF         COND(&PROG *EQ 'MMRPMCSIN') THEN(DO)                             /*BUG4745*/
             OVRDBF     FILE(DPTMVDZ3) TOFILE(DPTMVDY2) SHARE(*NO)                       /*BUG4745*/
             ENDDO                                                                       /*BUG4745*/
             IF         COND(&PROG *EQ 'MMLDNIRIN') THEN(DO)          /*CSE006*/
             OVRDBF     FILE(MMDELDL1) TOFILE(MMDELDL4)               /*CSE006*/
             ENDDO                                                    /*CSE006*/
             IF         COND(&PROG *EQ 'MMREPORIN') THEN(DO)          /*CSE006*/
/**********  OVRDBF     FILE(MMDELDL1) TOFILE(MMDELDL5) */                     /*CSE006*/ /*240276*/
             OVRDBF     FILE(MMDELDL6) TOFILE(MMDELDL5)                                   /*240276*/
             OVRDBF     FILE(DPTMVDY2) SHARE(*NO)                     /*CSE006*/
             OVRDBF     FILE(DPTMVDY1) SHARE(*NO)                     /*CSE006*/
             OVRDBF     FILE(DPTMVDL1) SHARE(*NO)                     /*CSE006*/
             OVRDBF     FILE(DPTMVDZ3) TOFILE(DPTMVDY2) SHARE(*NO)                        /*201230*/
             CPYF       FROMFILE(DPTMVD) TOFILE(QTEMP/SEDMRPXX) +
                          MBROPT(*REPLACE) CRTFILE(*YES)              /*CSE006*/
             MONMSG     MSGID(CPF0000)                                                    /*244860*/
             ENDDO                                                    /*CSE006*/
             IF         COND((&CAP067) *EQ 'Y') THEN(DO)                                  /*CAP067*/
                                                                                          /*CAP067*/
             IF         COND(&PROG *EQ 'MMREPORPR') THEN(DO)                              /*CAP067*/
             OVRDBF     FILE(MMIRPLDL2) SHARE(*NO)                                        /*CAP067*/
             OVRDBF     FILE(MMIRPDDL0) SHARE(*NO)                                        /*CAP067*/
             OVRDBF     FILE(MMIRPTRL0) SHARE(*NO)                                        /*CAP067*/
             OVRDBF     FILE(MMTRPDML0) SHARE(*NO)                                        /*CAP067*/
             OVRDBF     FILE(ZAFLDNPD)  MBR(MMLDNIPD)                                     /*CAP067*/
             OVRDBF     FILE(DPTMVDZ3) TOFILE(DPTMVDY2) SHARE(*NO)                        /*201230*/
                                                                                          /*240659*/
             CHKOBJ     OBJ(QTEMP/REPO) OBJTYPE(*DTAARA)                                  /*240659*/
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)                                   /*240659*/
             CRTDTAARA  DTAARA(QTEMP/REPO) TYPE(*CHAR) LEN(2) VALUE('  ')
             ENDDO                                                                        /*240659*/
                                                                                          /*240659*/
             ENDDO                                                                        /*CAP067*/
                                                                                          /*CAP067*/
             ENDDO                                                                        /*CAP067*/
/*/COPY WNCPYSRC,MMC0011008                                          */
             ENDDO                                                    /*CSE006*/
 
 
/*  CALL PROGRAM             */
 
             CALL       PGM(&PROG)
 
/************IF         COND(&PROG *EQ 'MMDEALRAT') THEN(DO)********/ /*CAP052*/
             IF         COND(&PROG *EQ 'MMDEALRAT' *OR +
                             &PROG *EQ 'MMPBDLRAT') THEN(DO)          /*CAP052*/
             DLTOVR     FILE(MMDEALL0)
             DLTOVR     FILE(MMDEALL2)                                /*CAP052*/
             DLTOVR     FILE(MMCMPLLL)
             DLTOVR     FILE(MMCARDLL)
             DLTOVR     FILE(MMDEAULL)                                /*CAP003*/
             DLTOVR     FILE(MMDELULL)                                /*CAP003*/
             ENDDO
/*/COPY WNCPYSRC,MMC0011010                                          */
 
             IF         COND((&CSE006) *EQ 'Y') THEN(DO)              /*CSE006*/
                                                                        /*CSE006*/
             IF         COND(&PROG *EQ 'MMREPOSIN') THEN(DO)            /*CSE006*/
             DLTOVR     FILE(MMCMPLLL)                                  /*CSE006*/
             DLTOVR     FILE(MMCARDLL)                                  /*CSE006*/
/**********  DLTOVR     FILE(MMDEALLL) */                                      /*CSE006*/ /*240276*/
             DLTOVR     FILE(MMDEALL0)                                                    /*240276*/
             DLTOVR     FILE(DPTMVDZ3)                                                    /*201230*/
             ENDDO                                                      /*CSE006*/
                                                                        /*CSE006*/
             IF         COND(&PROG *EQ 'MMLDNISIN') THEN(DO)            /*CSE006*/
             DLTOVR     FILE(MMCMPLLL)                                  /*CSE006*/
             DLTOVR     FILE(MMCARDLL)                                  /*CSE006*/
             DLTOVR     FILE(MMDEALLL)                                  /*CSE006*/
             ENDDO                                                      /*CSE006*/
                                                                        /*CSE006*/
             IF         COND(&PROG *EQ 'MMLDNIRIN') THEN(DO)            /*CSE006*/
             DLTOVR     FILE(MMDELDL1)                                  /*CSE006*/
             ENDDO                                                      /*CSE006*/
 
             IF         COND(&PROG *EQ 'MMRPMCSIN') THEN(DO)                             /*BUG4745*/
             DLTOVR     FILE(DPTMVDZ3)                                                   /*BUG4745*/
             ENDDO                                                                       /*BUG4745*/
                                                                        /*CSE006*/
             IF         COND(&PROG *EQ 'MMREPORIN') THEN(DO)            /*CSE006*/
/**********  DLTOVR     FILE(MMDELDL1) */                                      /*CSE006*/ /*240276*/
             DLTOVR     FILE(MMDELDL6)                                                    /*240276*/
             DLTOVR     FILE(DPTMVDY2)                                  /*CSE006*/
             DLTOVR     FILE(DPTMVDY1)                                  /*CSE006*/
             DLTOVR     FILE(DPTMVDL1)                                  /*CSE006*/
             DLTOVR     FILE(DPTMVDZ3)                                                    /*201230*/
             ENDDO                                                      /*CSE006*/
                                                                        /*CSE006*/
                                                                        /*CSE006*/
             IF         COND(&PROG *EQ 'MMREPORIN') THEN(DO)          /*CSE006*/
               DLTF       FILE(QTEMP/SEDMRPXX)                        /*CSE006*/
               DLTF       FILE(QTEMP/SEDMRPX1)                        /*CES006*/
               DLTF       FILE(QTEMP/SEDMRPX2)                        /*CSE006*/
             ENDDO                                                    /*CSE006*/
                                                                                          /*CAP067*/
             IF         COND((&CAP067) *EQ 'Y') THEN(DO)                                  /*CAP067*/
                                                                                          /*CAP067*/
             IF         COND(&PROG *EQ 'MMREPORPR') THEN(DO)                              /*CAP067*/
               DLTOVR     FILE(SEDMRPX1)                                                  /*CAP067*/
               DLTOVR     FILE(SEDMRPX2)                                                  /*CAP067*/
               DLTOVR     FILE(SECRTNTPPD)                                                /*CAP067*/
               DLTOVR     FILE(SECRTTTPPD)                                                /*CAP067*/
               DLTOVR     FILE(DPTMVDL1)                                                  /*CAP067*/
               DLTOVR     FILE(DPTMVDY1)                                                  /*CAP067*/
               DLTOVR     FILE(DPTMVDY2)                                                  /*CAP067*/
               DLTOVR     FILE(DPTMVDZ1)                                                  /*CAP067*/
               DLTOVR     FILE(DPTMVDZ1)                                                  /*CAP067*/
               DLTOVR     FILE(DPTMVDZ2)                                                  /*CAP067*/
               DLTOVR     FILE(DPTMVDZ3)                                                  /*201230*/
               DLTOVR     FILE(SECRTNL1)                                                  /*CAP067*/
               DLTOVR     FILE(SECRTTL1)                                                  /*CAP067*/
               DLTOVR     FILE(MMIRPLDL2)                                                 /*CAP067*/
               DLTOVR     FILE(MMIRPDDL0)                                                 /*CAP067*/
               DLTOVR     FILE(MMIRPTRL0)                                                 /*CAP067*/
               DLTOVR     FILE(MMTRPDML0)                                                 /*CAP067*/
               DLTOVR     FILE(ZAFLDNOD)                                                  /*CAP067*/
               DLTF       FILE(QTEMP/SEDMRPXX)                                            /*CAP067*/
               DLTF       FILE(QTEMP/SEDMRPX1)                                            /*CAP067*/
               DLTF       FILE(QTEMP/SEDMRPX2)                                            /*CAP067*/
             ENDDO                                                                        /*CAP067*/
                                                                                          /*CAP067*/
             ENDDO                                                                        /*CAP067*/
                                                                        /*CSE006*/
/*/COPY WNCPYSRC,MMC0011009                                          */
             ENDDO                                                    /*CSE006*/
/** +
    Destroy the activation group used by the program, and ensure +
    that no files were left open in OPM programs called from it. +
    First retrieve the name of the activation group that the +
    program runs in. +
**/
             CALL       PGM(ZAGETACTGP) PARM(&RETURNCODE &ACTGRP &PROG)
 
             IF         COND(&RETURNCODE = ' ') THEN(DO)
                RCLACTGRP  ACTGRP(&ACTGRP)
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/*********** RCLRSC  *********************/                                               /*CDL038*/
 
/*  IF U7 AND U8 ARE ON SEND DATA BASE ERROR MESSAGE TO MOPERQ */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
                RTVDTAARA  DTAARA(*LDA (134 50)) RTNVAR(&MSG)
                SNDPGMMSG  MSGID(DBM0001) MSGF(DRSMM) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ)
 
/*  CALL SCC0010 TO SEND ABNORMAL TERMINATION SCREEN  */
                RTVMSG     MSGID(SCM0087) MSGF(MIDASMSG) MSG(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
                CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
                RTVMSG     MSGID(SCM0088) MSGF(MIDASMSG) MSG(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
                CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
                CHGDTAARA  DTAARA(MIDASMSG (3 1)) VALUE('1')
                MONMSG     MSGID(CPF0000 MCH0000)
                CALL       PGM(SCC0010) PARM('MMC0011' 'ENTER' &NOREPLY)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                ROLLBACK
             ENDDO
 
 
 /* PROCESSING FOR CONFIRMATIONS */
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
 
       IF         COND(%SWITCH(XXXXX000)) THEN(DO)
 
 /* DO CONFIRMATIONS IF BACK OFFICE DEAL INPUT DONE */
 
 /********IF         COND((&PROG *EQ 'MMLDNISIN') +  */                                   /*195484*/
 /**********          *OR (&PROG *EQ 'MMNASPSIN') +  */                                   /*195484*/
 /**********          *OR (&PROG *EQ 'MMNASSSIN') +  */                                   /*195484*/
 /**********          *OR (&PROG *EQ 'MMDEAMSIN') +  */                                   /*195484*/
 /**********          *OR (&PROG *EQ 'MMILDNIMNT') + */                                   /*195484*/
 /**********          *OR (&PROG *EQ 'MMINASPMNT') + */                                   /*195484*/
 /**********          *OR (&PROG *EQ 'MMINASSMNT') + */                                   /*195484*/
 /**********          *OR (&PROG *EQ 'MMIDEAMMNT') + */                                   /*195484*/
 /**********          *OR (&PROG *EQ 'MMREPOSIN') +  */                                   /*195484*/
 /**********          *OR (&PROG *EQ 'MMRPMCSIN')) THEN(DO) */                 /*CSE006*/ /*195484*/
 /*                   *OR (&PROG *EQ 'MMIDEAMMNT')) THEN(DO)           /*CSE006*/
 /********IF         COND((&PROG *EQ 'MMLDNISIN') +                                       /*208051*/
 /**********          *OR (&PROG *EQ 'MMNASPSIN') +                                       /*208051*/
 /**********          *OR (&PROG *EQ 'MMNASSSIN') +                                       /*208051*/
 /**********          *OR (&PROG *EQ 'MMDEAMSIN') +                                       /*208051*/
 /**********          *OR (&PROG *EQ 'MMLDNIRPR') +                                       /*208051*/
 /**********          *OR (&PROG *EQ 'MMNASPRPR') +                                       /*208051*/
 /**********          *OR (&PROG *EQ 'MMNASSRPR') +                                       /*208051*/
 /**********          *OR (&PROG *EQ 'MMDEAMRPR') +                                       /*208051*/
 /**********          *OR (&PROG *EQ 'MMDEALRAT') +                                       /*208051*/
 /**********          *OR (&PROG *EQ 'MMLDNIRIN')) THEN(DO)                    /*195484*/ /*208051*/
 /********IF         COND((&PROG *EQ 'MMLDNISIN') +                                       /*CSW208*/
 /**********          *OR (&PROG *EQ 'MMNASPSIN') +                                       /*CSW208*/
 /**********          *OR (&PROG *EQ 'MMNASSSIN') +                                       /*CSW208*/
 /**********          *OR (&PROG *EQ 'MMDEAMSIN') +                                       /*CSW208*/
 /**********          *OR (&PROG *EQ 'MMLDNIRPR') +                                       /*CSW208*/
 /**********          *OR (&PROG *EQ 'MMNASPRPR') +                                       /*CSW208*/
 /**********          *OR (&PROG *EQ 'MMNASSRPR') +                                       /*CSW208*/
 /**********          *OR (&PROG *EQ 'MMDEAMRPR') +                                       /*CSW208*/
 /**********          *OR (&PROG *EQ 'MMDEALRAT') +                                       /*CSW208*/
 /**********          *OR (&PROG *EQ 'MMLDNIRIN') +                                       /*CSW208*/
 /**********          *OR (&PROG *EQ 'MMPBDLRAT') +                                       /*CSW208*/
 /**********          *OR (&PROG *EQ 'MMREPOSIN') +                                       /*CSW208*/
 /**********          *OR (&PROG *EQ 'MMREPORIN') +                                       /*CSW208*/
 /**********          *OR (&PROG *EQ 'MMRPMCSIN')) THEN(DO)                    /*208051*/ /*CSW208*/
          IF         COND((&PROG *EQ 'MMLDNISIN') +
                      *OR (&PROG *EQ 'MMNASPSIN') +
                      *OR (&PROG *EQ 'MMNASSSIN') +
                      *OR (&PROG *EQ 'MMDEAMSIN') +
                      *OR (&PROG *EQ 'MMLDNIRPR') +
                      *OR (&PROG *EQ 'MMNASPRPR') +
                      *OR (&PROG *EQ 'MMNASSRPR') +
                      *OR (&PROG *EQ 'MMDEAMRPR') +
                      *OR (&PROG *EQ 'MMDEALRAT') +
                      *OR (&PROG *EQ 'MMLDNIRIN') +
                      *OR (&PROG *EQ 'MMPBDLRAT') +
                      *OR (&PROG *EQ 'MMREPOSIN') +
                      *OR (&PROG *EQ 'MMREPORIN') +
                      *OR (&PROG *EQ 'MMRPMCSIN') +
                      *OR (&PROG *EQ 'DLDLFESIN') +
                      *OR (&PROG *EQ 'DLDLFERPR')) THEN(DO)                               /*CSW208*/
 
             IF         COND((%SST(&MMOD 25 1) *EQ 'Y') *OR  +
                           (%SST(&MMOD 33 1) *EQ 'Y')) THEN(DO)
 
                RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
 
 /* CHECK THAT CONFIRMATION PROCESS IS NOT ALREADY RUNNING */
 
                IF         COND(%SST(&DLSTAT 6 2) *EQ 'NN') THEN(DO)
 
/************      ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))            *180276*/
/************      CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE('Y')          *180276*/
/************      DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))            *180276*/
                   SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
 
/************      SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +                    /*CSC023*/
/************                   RTGDTA(*JOBD) RQSDTA('CALL   DLC0210A') +                 /*CSC023*/
/************                   INLLIBL(*JOBD) MSGQ(MOPERQ)                               /*CSC023*/
/************      SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                    /*CSC023*/
/************                   RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                   /*CSC023*/
/************                   INLLIBL(*JOBD) MSGQ(MOPERQ)                               /*CSC023*/
 
                   SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +
                                RTGDTA(*JOBD) RQSDTA('CALL   DLC0210A') +
                                INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                   /*CSC023*/
                   SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                                RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                                INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                   /*CSC023*/
 
                   RCVF
 
                   IF         COND(&ENAPRG *EQ 'Y') THEN(DO)
                      CALL  PGM(FCC0201) PARM('DLC0211' '10001' +
                      'DL0308' 'B')
                   ENDDO
                ENDDO
 
             ENDDO
 
             ELSE   DO
 
                RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
 
 /* CHECK THAT CONFIRMATION PROCESS IS NOT ALREADY RUNNING */
 
                IF         COND(%SST(&DLSTAT 6 1) *EQ 'N') THEN(DO)
 
/***********       ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))            *180276*/
/***********       CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE('Y')          *180276*/
/***********       DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))            *180276*/
                   SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
 
/************      SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +                    /*CSC023*/
/************                   RTGDTA(*JOBD) RQSDTA('CALL   DLC0210A') +                 /*CSC023*/
/************                   INLLIBL(*JOBD) MSGQ(MOPERQ)                               /*CSC023*/
/************      SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                    /*CSC023*/
/************                   RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                   /*CSC023*/
/************                   INLLIBL(*JOBD) MSGQ(MOPERQ)                               /*CSC023*/
 
                   SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +
                                RTGDTA(*JOBD) RQSDTA('CALL   DLC0210A') +
                                INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                   /*CSC023*/
                   SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                                RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                                INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                   /*CSC023*/
 
                   RCVF
 
                   IF         COND(&ENAPRG *EQ 'Y') THEN(DO)
                      CALL  PGM(FCC0202) PARM('DLC0211' '10001' +
                      'DL0308' 'B')
                   ENDDO
                ENDDO
             ENDDO
          ENDDO
       ENDDO
                                                                                          /*CRE020*/
/* Print Retail Advices if CRE020 is enabled. */                                          /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(%SWITCH(XXXXXX00) *AND +
                              &CRE020 *EQ 'Y') THEN(DO)                                   /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&PMOD) VALUE('          ')                                    /*CRE020*/
                                                                                          /*CRE020*/
/** Change &PROG if equal to 'MMREPOSIN'. To print advice, program */                    /*BUG3128*/
/** maintenance field in READVCPD should be equal to &PROG. */                           /*BUG3128*/
                                                                                         /*BUG3128*/
             IF         COND(&PROG *EQ 'MMREPOSIN') THEN(DO)                             /*BUG3128*/
             CHGVAR     VAR(&PROG) VALUE('MMLDNISIN')                                    /*BUG3128*/
             ENDDO                                                                       /*BUG3128*/
                                                                                         /*BUG3128*/
             IF         COND((&PROG *EQ 'MMLDNISIN') *OR +
                             (&PROG *EQ 'MMLDNIRPR') *OR +
                             (&PROG *EQ 'MMNASPSIN') *OR +
                             (&PROG *EQ 'MMNASPRPR') *OR +
                             (&PROG *EQ 'MMNASSSIN') *OR +
                             (&PROG *EQ 'MMNASSRPR') *OR +
                             (&PROG *EQ 'MMDEAMSIN') *OR +
                             (&PROG *EQ 'MMDEAMRPR')) THEN(DO)                            /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&PMOD) VALUE(%SST(&PROG 1 6) *CAT 'UPD')                      /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&PCMD) VALUE('CALL PGM(REC000881) PARM(''' +
                        *CAT &PMOD *CAT ''' ''DL'')')                                     /*CRE020*/
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                        RTGDTA(*JOBD) RQSDTA(&PCMD) +
                        INLLIBL(*JOBD) MSGQ(MOPERQ)                                       /*CRE020*/
                                                                                          /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND((&PROG *EQ 'MMDEALRAT') *OR +
                             (&PROG *EQ 'MMPBDLRAT')) THEN(DO)                            /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&PCMD) VALUE('CALL PGM(REC000881) PARM(' +
                        *CAT '''MMLDNIUPD'' ''DL''' *CAT ')')                             /*CRE020*/
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                        RTGDTA(*JOBD) RQSDTA(&PCMD) +
                        INLLIBL(*JOBD) MSGQ(MOPERQ)                                       /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&PCMD) VALUE('CALL PGM(REC000881) PARM(' +
                        *CAT '''MMNASPUPD'' ''DL''' *CAT ')')                             /*CRE020*/
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                        RTGDTA(*JOBD) RQSDTA(&PCMD) +
                        INLLIBL(*JOBD) MSGQ(MOPERQ)                                       /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&PCMD) VALUE('CALL PGM(REC000881) PARM(' +
                        *CAT '''MMNASSUPD'' ''DL''' *CAT ')')                             /*CRE020*/
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                        RTGDTA(*JOBD) RQSDTA(&PCMD) +
                        INLLIBL(*JOBD) MSGQ(MOPERQ)                                       /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&PCMD) VALUE('CALL PGM(REC000881) PARM(' +
                        *CAT '''MMDEAMUPD'' ''DL''' *CAT ')')                             /*CRE020*/
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                        RTGDTA(*JOBD) RQSDTA(&PCMD) +
                        INLLIBL(*JOBD) MSGQ(MOPERQ)                                       /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             ENDDO                                                                        /*CRE020*/
 
/*********** RCLRSC  *********************/                                               /*CDL038*/
/*/COPY WNCPYSRC,MMC0011003                                          */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 END:        ENDPGM
