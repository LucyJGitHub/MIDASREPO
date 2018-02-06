/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AK Lending A/c Keys Generation Menu')           */
/*********************************************************************/
/*                                                                   */
/*   Midas - Account Key Generator                                   */
/*                                                                   */
/*      AKC40  - Lending Account Keys Generation Menu                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Prev Amend No. 237299             Date 04Dec06              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      131108             Date 06Oct98              */
/*                      CLE007             Date 11Sep97              */
/*                      092374             Date 07Jan97              */
/*                  S01408             Date 04MAY95                  */
/*                  072797             Date 15FEB95                  */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   MD046248 - Finastra Rebranding                                  */
/*   237299 - Not all keys in the work file were transferred in the  */
/*            Live file.                                             */
/*   131108 - Screen not redisplayed after output of U5 message      */
/*            which requires shortening                              */
/*   CLE007 - Customer Lending Enhancement - Others                  */
/*   092374 - Forsees problem of Duplicate Keys                      */
/*   S01408 - Addition of core hook AKC40MP1                         */
/*   072797 - Customer Lending A/C Key Generation for Fees           */
/*                                                                   */
/*********************************************************************/
             PGM
/*                                                                   */
             DCLF       FILE(*LIBL/AKC40DF)
/*                                                                   */
             DCL       VAR(&JOB)    TYPE(*CHAR) LEN(10)
             DCL       VAR(&USRID)  TYPE(*CHAR) LEN(10)
             DCL       VAR(&LDA)    TYPE(*CHAR) LEN(256)
             DCL       VAR(&MEM)    TYPE(*CHAR) LEN(50)
             DCL       VAR(&DMLIB)  TYPE(*CHAR) LEN(7)
             DCL       VAR(&LIBR)   TYPE(*CHAR) LEN(2)
             DCL       VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL       VAR(&RUNA)   TYPE(*CHAR) LEN(7)
             DCL       VAR(&WRN)    TYPE(*LGL)  LEN(1)  VALUE('0')
             DCL       VAR(&POPTN)  TYPE(*CHAR) LEN(1)                /*072797*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CLE007*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CLE007*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CLE007*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CLE007*/
             DCL        VAR(&CLE007) TYPE(*CHAR) LEN(1) VALUE(' ')    /*CLE007*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                   */
/* Create LDA if it does not already exist.                          */
/*                                                                   */
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT'))
 
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&RUNA)
             RTVJOBA    JOB(&JOB) USER(&USRID)
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(END))
             CHGJOB     SWS(00000000)
/*                                                                   */
/*  Set up Copyright                                                 */
/*                                                                   */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             OVRDBF     FILE(ZACKEYAL) SEQONLY(*NO)
/*                                                                   */
/* Set up DM library with correct prefix.                            */
/*                                                                   */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&LIBR) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&DMLIB) VALUE(&LIBR *TCAT 'DMLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,AKC40MP1                                            */
                                                                      /*S01408*/
/*                                                                   */
/* Create CHECKAK object - used to check if any records in work file */
/*                                                                   */
             CHKOBJ     OBJ(QTEMP/CHECKAK) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDUPOBJ  OBJ(ZACKEYAL) FROMLIB(&DMLIB) +
                          OBJTYPE(*FILE) TOLIB(QTEMP) NEWOBJ(CHECKAK) +
                          DATA(*YES)
             ENDDO
/*                                                  */                /*CLE007*/
/* Check if Enhancement Number CLE007 is present.   */                /*CLE007*/
/*                                                  */                /*CLE007*/
             CHGVAR     VAR(&IN82) VALUE('0')                         /*CLE007*/
             CHGVAR     VAR(&CLE007) VALUE(' ')                       /*CLE007*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CLE007*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CLE007*/
             CHGVAR     VAR(&SAR) VALUE('CLE007')                     /*CLE007*/
                                                                      /*CLE007*/
             CHGJOB     SWS(XXXXXX00)                                 /*CLE007*/
                                                                      /*CLE007*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CLE007*/
                                                                      /*CLE007*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CLE007*/
                 CHGVAR     VAR(&CLE007) VALUE('Y')                   /*CLE007*/
                 CHGVAR     VAR(&IN82) VALUE('1')                     /*CLE007*/
             ENDDO
             ELSE       CMD(IF COND(&RTCD *NE '*NRF   ') THEN(GOTO +
                          CMDLBL(DBERR)))                             /*CLE007*/
/*                                                                   */
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/* Display menu. User may enter '1' or '2'.                          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
   RDSPLY:   SNDRCVF    RCDFMT(MENULE1)
             SNDPGMMSG  MSGID(CPI9801) MSGF(QCPFMSG) TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
/*                                                                 */
/* If F3 pressed, send warning message if keys still exist in work */
/* file.                                                           */
/*                                                                 */
             IF         COND(&IN03) THEN(DO)
              IF         COND(&WRN) THEN(DO)
              CLRPFM     FILE(*LIBL/ZACKEYAL)
              GOTO       CMDLBL(END)
              ENDDO
             ELSE       CMD(DO)
              CPYF       FROMFILE(*LIBL/ZACKEYAL) TOFILE(QTEMP/CHECKAK) +
                          MBROPT(*REPLACE)
              MONMSG     MSGID(CPF2817) EXEC(GOTO CMDLBL(END))
/*                                                                  */
              SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('There +
                          are still keys in the work file which +
                          will be lost unless you transfer') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)
              CHGVAR     VAR(&WRN) VALUE('1')
              GOTO       CMDLBL(RDSPLY)
             ENDDO
             ENDDO
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*  Menu option 1  -  Input generation parameters & produce report   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*********** IF         COND(&OPTION *EQ '1') THEN(DO)             */ /*072797*/
/*********** IF         COND(&OPTION *EQ '1' *OR &OPTION *EQ '2') +*/ /*CLE007*/
             IF         COND(&OPTION *EQ '1' *OR &OPTION *EQ '2'  +
                        *OR &OPTION *EQ '3' *AND &CLE007 *EQ 'Y') +
                          THEN(DO)                                    /*072797*/
             CPYF       FROMFILE(*LIBL/ZACKEYAL) TOFILE(QTEMP/CHECKAK) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817)  EXEC(DO)
 GENERATE:   CLRPFM     FILE(*LIBL/ZACKEYAL)
 
/*                                                                   */
/* Call RPG Generation Program & monitor for messages                */
/*                                                                   */
             IF         COND(&OPTION *EQ '1') THEN(DO)                /*072797*/
             CALL       PGM(AK0040)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
             SNDPGMMSG  MSG('Lending Generation failed. Re-input +
                          necessary. Press ENTER to continue.') +
                          TOPGMQ(*EXT)
             GOTO       CMDLBL(END)
             ENDDO
             ENDDO                                                    /*072797*/
/*********** ELSE       CMD(DO)                            /*072797*/ /*CLE007*/
             ELSE       CMD(IF COND(&OPTION *EQ '2') THEN(DO))        /*CLE007*/
             CALL       PGM(AK0045)                                   /*072797*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)       /*072797*/
             SNDPGMMSG  MSG('Lending Generation failed. Re-input +
                          necessary. Press ENTER to continue.') +
                          TOPGMQ(*EXT)                                /*072797*/
             GOTO       CMDLBL(END)                                   /*072797*/
             ENDDO                                                    /*072797*/
             ENDDO                                                    /*072797*/
             ELSE       CMD(IF COND(&OPTION *EQ '3' *AND &CLE007 *EQ +
                          'Y') THEN(DO))                              /*CLE007*/
                CALL       PGM(AK0046)                                /*CLE007*/
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)    /*CLE007*/
                SNDPGMMSG  MSG('Lending Generation failed. Re-input +
                              necessary. Press ENTER to continue.') +
                           TOPGMQ(*EXT)                               /*CLE007*/
                GOTO       CMDLBL(END)                                /*CLE007*/
                ENDDO                                                 /*CLE007*/
             ENDDO                                                    /*CLE007*/
             RTVJOBA    JOB(&JOB)
/* N.B.                                                              */
/* Database errors handled by Access Objects in RPG ACKEYLE.         */
/*                                                                   */
/* If Lending Generation returns normally, test if keys generated    */
/* successfully, produce report and redisplay menu.                  */
/*                                                                   */
             CHGVAR     VAR(&POPTN) VALUE(&OPTION)                    /*072797*/
             CHGVAR     VAR(&OPTION) VALUE(' ')
             CPYF       FROMFILE(*LIBL/ZACKEYAL) TOFILE(QTEMP/CHECKAK) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817)  EXEC(GOTO  CMDLBL(RDSPLY))
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Keys +
                          are being generated..') TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
             DLYJOB     DLY(3)
/*                                                                   */
/*   Call RPG Report Program & monitor for messages.                 */
/*                                                                   */
/*********** CALL       PGM(AK0140)                                */ /*072797*/
             CALL       PGM(AK0140) PARM(&POPTN)                      /*072797*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
             SNDPGMMSG  MSG('Report failed. Press ENTER to +
                          continue.') TOPGMQ(*EXT)
             GOTO       CMDLBL(END)
             ENDDO
             GOTO       CMDLBL(RDSPLY)
             ENDDO
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/* Display error screen if keys already exist in temporary file      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
   RDSPLY2:  SNDRCVF    RCDFMT(MENULE2)
             SNDPGMMSG  MSGID(CPI9801) MSGF(QCPFMSG) TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
/*                                                                   */
/***If*'A'*entered,*clear*file*and*generate*new*set*of*keys.********/ /*072797*/
/*  If 'A' entered, clear file and return to menu of options.      */ /*072797*/
/*                                                                   */
             IF         COND(&REPLY *EQ 'A') THEN(DO)
             CHGVAR     VAR(&OPTION) VALUE(' ')
             CHGVAR     VAR(&REPLY)  VALUE(' ')
             CLRPFM     FILE(*LIBL/ZACKEYAL)                          /*072797*/
/*********** GOTO CMDLBL(GENERATE)                                 */ /*072797*/
             GOTO CMDLBL(RDSPLY)                                      /*072797*/
             ENDDO
/*                                                                   */
/*  If 'B' entered, do not generate & return to menu of options.     */
/*                                                                   */
             IF         COND(&REPLY *EQ 'B') THEN(DO)
             CHGVAR     VAR(&OPTION) VALUE(' ')
             CHGVAR     VAR(&REPLY)  VALUE(' ')
             GOTO CMDLBL(RDSPLY)
             ENDDO
/*                                                                   */
/*  If F3 pressed, send error message.                               */
/*                                                                   */
             IF         COND(&IN03) THEN(DO)
             CHGVAR     VAR(&IN03) VALUE('0')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGDTA('Function Key not allowed') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)
             GOTO       CMDLBL(RDSPLY2)
             ENDDO
/*                                                                   */
/*  If neither 'A' or 'B' entered, display error message.            */
/*                                                                   */
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Invalid +
                          option - enter A or B') TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
             GOTO       CMDLBL(RDSPLY2)
             ENDDO
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/***Menu*option*2**-**Transfer*generated*keys*to*live*files*********/ /*072797*/
/*  Menu option 3  -  Transfer generated keys to live files        */ /*072797*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*********** IF         COND(&OPTION *EQ '2') THEN(DO)             */ /*072797*/
/*********** IF         COND(&OPTION *EQ '3') THEN(DO)     /*072797*/ /*CLE007*/
             IF         COND((&OPTION *EQ '3' *AND &CLE007 *NE 'Y') +
                          *OR (&OPTION *EQ '4' *AND &CLE007 *EQ 'Y')) +
                          THEN(DO)                                    /*CLE007*/
             CPYF       FROMFILE(*LIBL/ZACKEYAL) TOFILE(QTEMP/CHECKAK) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) EXEC(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('There +
                          are no keys in the work file - use option +
                          1 to generate') TOPGMQ(*EXT) MSGTYPE(*STATUS)
             GOTO       CMDLBL(RDSPLY)
             ENDDO
/*                                                                   */
/*   Call RPG to update live files and monitor for errors.           */
/*                                                                   */
             CHGJOB SWS(XXXX0XXX)                                   /*092374*/
             CALL       PGM(AK0100)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
             SNDPGMMSG  MSG('Transfer failed. Enter to continue.') +
                          TOPGMQ(*EXT)
             GOTO       CMDLBL(END)
             ENDDO
             RTVJOBA    JOB(&JOB)
/*                                                                   */
/* For database errors recover data from LDA.                        */
/*                                                                   */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
/*********************************************************************092374*/
/**If*Lending*Transfer*completes*normally,*clear*work*file*and********092374*/
/**redisplay*menu.****************************************************092374*/
/* If Lending Transfer completes normally, do not clear work file     092374*/
/* redisplay menu.                                                    092374*/
/*                                                                    092374*/
             CHGVAR     VAR(&OPTION) VALUE(' ')
/************CLRPFM     FILE(*LIBL/ZACKEYAL)                          092374*/
             IF         COND(%SWITCH(XXXX1XXX)) THEN(DO)            /*092374*/
/*           SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Keys +   /*131108*/
/*                     transferred successfully to live but some +
/*                     A/C keys are double and are still in work file +
/*                     If you want to transfer again don''t forget to  +
/*                     delete same keys in master file or come back at the-
/*                     the begining to clear work file') +
/*                     TOPGMQ(*EXT) MSGTYPE(*STATUS)           /*092374 131108*/
/*           SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Not all +
                          Keys transferred to live.  Some +
                          duplicates exist in the work file') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)                     */ /*131108*/ /*237299*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Duplicate +
                          keys in work file has overridden same keys +
                          in the Live file.') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)                                   /*237299*/
             GOTO       CMDLBL(RDSPLY)                                /*131108*/
             ENDDO                                                  /*092374*/
             ELSE DO                                                /*092374*/
             CLRPFM     FILE(*LIBL/ZACKEYAL)                        /*092374*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Keys +
                          transferred successfully to live file') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)
             GOTO       CMDLBL(RDSPLY)
             ENDDO                                                  /*092374*/
             ENDDO
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*  Invalid menu option - send error message.                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*********** IF         COND(&OPTION *NE '1' *AND &OPTION *NE '2') +  /*072797*/
/***********              THEN(DO)                                 */ /*072797*/
/*********** SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Invalid +/*072797*/
/***********              option - enter 1 or 2') TOPGMQ(*EXT) +      /*072797*/
/***********              MSGTYPE(*STATUS)                         */ /*072797*/
             IF         COND(&CLE007 *NE 'Y') THEN(DO)                /*CLE007*/
             IF         COND(&OPTION *NE '1' *AND &OPTION *NE '2' +
                          *AND &OPTION *NE '3') THEN(DO)              /*072797*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Invalid +
                          option - enter 1, 2, or 3') TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)                            /*072797*/
             ENDDO
             ENDDO                                                    /*CLE007*/
             ELSE       CMD(DO)                                       /*CLE007*/
             IF         COND(&OPTION *NE '1' *AND &OPTION *NE '2' +
                          *AND &OPTION *NE '3' *AND &OPTION *NE +
                          '4') THEN(DO)                               /*CLE007*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Invalid +
                          option - enter 1, 2, 3 or 4') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)               /*CLE007*/
             ENDDO                                                    /*CLE007*/
             ENDDO                                                    /*CLE007*/
/*                                                                   */
             GOTO       CMDLBL(RDSPLY)
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/* Error handling.                                                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
  DBERR:     RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(*LIBL/MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(*LIBL/MOPERQ)
             GOTO       CMDLBL(END)
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/* Close of program processing.                                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
  END:
             DLTF       FILE(QTEMP/CHECKAK)
             CLRPFM     FILE(*LIBL/ZACKEYAL)
             RETURN
             ENDPGM
