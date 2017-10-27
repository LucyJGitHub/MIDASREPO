/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ME Start Meridian links')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management                                  */
/*                                                                   */
/*       MEC0720 - Start meridian links                              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/*       Last Amend No. MD048403           Date 27Oct17              */
/*       Prev Amend No. MD033914           Date 26Oct17              */
/*                      AR1031152          Date 06Dec12              */
/*                      AR549937           Date 27Jul12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*                      240627             Date 25Sep06              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG5980            Date 30Mar05              */
/*                      BUG3866            Date 29Jul04              */
/*                      CSW034             Date 09Jan04              */
/* Midas Release 4.01.01 --------------------------------------------*/
/*                      207006  *CREATE    Date 31Jul02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSW025  *CREATE    Date 06Mar02              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD048403 - Cannot compile due to missing command WRKMLCASIF.*/
/*                  (Temporary Fix)Remove WRKMLCASIF and related     */
/*                  commands.                                        */
/*       MD033914 - Housekeep DTAQs in xxDPLIB                       */
/*                - Applied for MD047530.                            */
/*       AR1031152 - Error issuing WRKMMMSVR command which calls     */
/*                   program MEC2100. Issue command when CSW038 is   */
/*                   switched OFF. (Child: AR1031154)                */
/*       AR549937 - Cob component ICIFINISH in LCKW status.  Applied */
/*                  GEMS 256759.  (Child: AR691023).                 */
/*       240627 - *DTAARA created by MMM jobs  in lib PHXLIB         */
/*                not deleted.                                       */
/*       BUG5980 - Add mode parameter to WRKMSMIF to restart jobs    */
/*                 that are set to automatic.                        */
/*       BUG3866- Meridian Server should not be started nor ended    */
/*                Global Processing is ON.                           */
/*       CSW034 - Midas Message Manager Global Processing            */
/*       207006 - Remove wait for message manager                    */
/*       CSW025 - Midas Message Manager                              */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MRDEOD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MNGSYS) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&MDL2CASLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CURLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSW026) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*207006*/
             DCL        VAR(&CSW034) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSW034*/
             DCL        VAR(&CSW038) TYPE(*CHAR) LEN(1) VALUE(' ')                     /*AR1031152*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*207006*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*207006*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*207006*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*207006*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(02)                                  /*240627*/
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)                                    /*240627*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)                                 /*MD033914*/
             DCL        VAR(&DTQMC) TYPE(*CHAR) LEN(10)                                 /*MD033914*/

             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERROR)

             CHGJOB     SWS(00000000)

             RTVJOBA    CURLIB(&CURLIB)

             RTVDTAARA  DTAARA(MESTAT (50 1)) RTNVAR(&MNGSYS)

/* Check if Midas Message Manager/CASmf interface being used */                           /*207006*/
             CHGVAR     VAR(&CSW026) VALUE(' ')                                           /*207006*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*207006*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*207006*/
             CHGVAR     VAR(&SAR) VALUE('CSW026')                                         /*207006*/
             CHGJOB     SWS(XXXXXX00)                                                     /*207006*/
                                                                                          /*207006*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*207006*/
                                                                                          /*207006*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*207006*/
                 CHGVAR     VAR(&CSW026) VALUE('Y')                                       /*207006*/
             ENDDO                                                                        /*207006*/
             ELSE       CMD(IF COND(&RTCD *NE '*NRF   ') THEN(GOTO +
                          CMDLBL(DBERR)))                                                 /*207006*/
                                                                                          /*207006*/
             CALL (AOSARDR0) PARM(&RTCD '*VERIFY' 'CSW034')                               /*CSW034*/
                                                                                          /*CSW034*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                                      /*CSW034*/
                CHGVAR     VAR(&CSW034) VALUE('Y')                                        /*CSW034*/
             ENDDO                                                                        /*CSW034*/
                                                                                       /*AR1031152*/
             CALL (AOSARDR0) PARM(&RTCD '*VERIFY' 'CSW038')                            /*AR1031152*/
                                                                                       /*AR1031152*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                                   /*AR1031152*/
                CHGVAR     VAR(&CSW038) VALUE('Y')                                     /*AR1031152*/
             ENDDO                                                                     /*AR1031152*/

/* Delete MSMR* data areas @ XLIB for housekeeping purposes. */                         /*AR549937*/
                                                                                        /*AR549937*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)                            /*AR549937*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                  /*AR549937*/
             CHGVAR     VAR(&XLIB) VALUE(&PREFIX *CAT 'XLIB')                           /*AR549937*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                  /*AR549937*/
                                                                                        /*AR549937*/
             DLTDTAARA  DTAARA(&XLIB/MSMR*)                                             /*AR549937*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                  /*AR549937*/
                                                                                        /*AR549937*/
             CHGVAR     VAR(&DTQMC) VALUE('MSQ*')                                       /*MD033914*/
             CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *CAT 'DPLIB')                         /*MD033914*/
             DLTDTAQ    DTAQ(&DPLIB/&DTQMC)                                             /*MD033914*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                  /*MD033914*/
                                                                                        /*MD033914*/
/* Start Export from this Midas system to Meridian. */
/**********  WRKMSMIF   OPERATION(*EOD) MCID(*ALL) */                                    /*BUG5980*/
             WRKMSMIF   OPERATION(*EOD) MCID(*ALL) MODE(*AUTO)                           /*BUG5980*/
/************IF COND(&MNGSYS *EQ 'Y') THEN(DO)                                              CSW034*/
/**********  IF COND((&MNGSYS *EQ 'Y') *AND (&CSW034 *EQ 'Y')) THEN(DO) */        /*CSW034 BUG3866*/
             IF COND((&MNGSYS *EQ 'Y') *AND (&CSW034 *NE 'Y')) THEN(DO)                  /*BUG3866*/
/* If this is the managing Midas system also start Meridian. */

/* Set off Meridian EoD enabled flag.  This will be set on once */
/*  the Rundate Synchronisation message has been sent.          */
                CHGDTAARA  DTAARA(MESTAT (49 1)) VALUE(' ')
/* Start Meridian Message Manager server. */
                IF COND(&CSW038 *NE 'Y') THEN(DO)                                      /*AR1031152*/
                WRKMMMSVR  ACTION(*STARTUP)
                ENDDO                                                                  /*AR1031152*/
/* Start Meridian - SWIFT (CAS) interface. */
                IF         COND(&CSW026 *EQ 'Y') THEN(DO)                                 /*207006*/
/*              RTVDTAARA  DTAARA(MESTAT (61 10)) RTNVAR(&MDL2CASLIB)                   /*MD048403*/
/*              CHGCURLIB  CURLIB(&MDL2CASLIB)                                          /*MD048403*/
/*              WRKMLCASIF   OPERATION(*STARTUP)                                        /*MD048403*/
                ENDDO                                                                     /*207006*/
/* Reset the current library. */
                IF         COND(&CURLIB *EQ '*NONE     ') THEN(DO)
                   CHGCURLIB  CURLIB(*CRTDFT)
                ENDDO
                ELSE       CMD(DO)
                   CHGCURLIB  CURLIB(&CURLIB)
                ENDDO
                GOTO END                                                                  /*207006*/
LOOP:
                RTVDTAARA  DTAARA(MESTAT (49 1)) RTNVAR(&MRDEOD)
                IF         COND(&MRDEOD *NE 'Y') THEN(DO)
                   DLYJOB     DLY(60)
                   GOTO LOOP
                ENDDO
             ENDDO

             GOTO       CMDLBL(END)
DBERR:                                                                                    /*207006*/
             CHGVAR     VAR(&MSG) VALUE('Switchable Features error')                      /*207006*/
                                                                                          /*207006*/
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) +
                          MSGTYPE(*INFO)                                                  /*207006*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                    /*207006*/
             CHGJOB     SWS(XXXXXX11)                                                     /*207006*/
             GOTO       CMDLBL(END)                                                       /*207006*/
                                                                                          /*207006*/
ERROR:
             CHGVAR     VAR(&MSG) VALUE('Start meridian links failure')

             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) +
                          MSGTYPE(*INFO)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)

END:
/**Delete*MSMR***data*areas*@*XLIB*for*housekeeping*purpose.**/                           /*240627*/
/***********                                                 */                  /*240627 AR549937*/
/*********** RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX) */                  /*240627 AR549937*/
/*********** MONMSG     MSGID(CPF0000 RPG0000 MCH0000)       */                  /*240627 AR549937*/
/*********** CHGVAR     VAR(&XLIB) VALUE(&PREFIX *CAT 'XLIB')*/                  /*240627 AR549937*/
/*********** MONMSG     MSGID(CPF0000 RPG0000 MCH0000)       */                  /*240627 AR549937*/
/***********                                                 */                  /*240627 AR549937*/
/*********** DLTDTAARA  DTAARA(&XLIB/MSMR*)                  */                  /*240627 AR549937*/
/*********** MONMSG     MSGID(CPF0000 RPG0000 MCH0000)       */                  /*240627 AR549937*/
/***********                                                 */                  /*240627 AR549937*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
