/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ME BIC Plus loader')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management                                  */
/*                                                                   */
/*       MEC1420  -  BIC Plus loader                                 */
/*                                                                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD024820           Date 08May14              */
/*       Prev Amend No. 262490             Date 07Nov09              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CFT040             Date 15Sep08              */
/*                      CFT035             DATE 03Feb07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CFT007             DATE 08NOV99              */
/*                      Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD024820 - Some SWIFT BIC were not deleted due to locking   */
/*       262490 - If Full files and CFT040  then clear MEBICPPD      */
/*       CFT040 - BIC Plus IBAN                                      */
/*       CFT035 - BIC Database Changes 2007                          */
/*       CFT007 - BIC Database Plus Integration                      */
/*                                                                   */
/*********************************************************************/
/*  INDICATOR USAGE                                                  */
/*  ---------------                                                  */
/*                                                                   */
/* N31    Wait for an answer Y/N for updating the BIC directory      */
/*  49    Display BIC Plus IBAN on screen                            */                   /*CFT040*/
/*  50    Display 'Downloading BIC Database Plus Data'               */                   /*CFT035*/
/*  51    Display 'Updating BIC Database plus table '                */
/*  52    Display 'Updating BIC Country plus table  '                */
/*  53    Display 'Rebuilding BIC Database plus search index'        */
/*  54    Display 'Updating the BIC Directory table'                 */
/*  55    Display 'BIC Database plus successfully updated '          */
/*  60    Display 'S.W.I.F.T. files not found'                       */                   /*CFT040*/
/*  61    Display 'Generation of BIC upload control data from....'   */                   /*CFT040*/
/*  62    Display 'Delta upload failed'                              */                   /*CFT040*/
/*  63    Display 'Uploading BIC Plus IBAN/Country data delta'       */                   /*CFT040*/
/*  64    Display 'Uploading BIC Plus IBAN/Country data full'        */                   /*CFT040*/
/*  65    Display 'BIC Database updater has failed'                  */                   /*CFT040*/
/*  66    Display 'Updating BIC Plus Table based on BIC Plus IBAN..' */                   /*CFT040*/
/*  71    Display 'Wrong format of file name'                        */                   /*CFT040*/
/*  72    Display 'IBAN Structure file (IS) is empty'                */                   /*CFT040*/
/*  73    Display 'BIC Plus IBAN file (BI) is empty'                 */                   /*CFT040*/
/*  74    Display 'BIC Countries file (CT) is empty'                 */                   /*CFT040*/
/*  75    Display 'Either files sent is not complete or error in...' */                   /*CFT040*/
/*  76    Display 'CT file has invalid data'                         */                   /*CFT040*/
/*  77    Display 'BI file has invalid data'                         */                   /*CFT040*/
/*  78    Display 'IS file has invalid data'                         */                   /*CFT040*/
/*                                                                   */
/*********************************************************************/
             PGM
 
/* Copyright statement                                               */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&REL_DAT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RET_COD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CFT035*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CFT035*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CFT035*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CFT035*/
             DCL        VAR(&CFT035) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CFT035*/
             DCL        VAR(&CFT040) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CFT040*/
             DCL        VAR(&ERRTYP) TYPE(*CHAR) LEN(1) VALUE('0')                        /*CFT040*/
 
 
             DCLF       FILE(ME1420DF)
 
/* Global Monitor Message                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNOR)                                               /*CFT035*/
/**************************EXEC(GOTO ENDCLPGM) */                                         /*CFT035*/
             CHGJOB     SWS(00000000)                                                     /*CFT035*/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)                            /*CFT040*/
             MONMSG     MSGID(CPF1023)                                                    /*CFT040*/
 
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                                       /*CFT035*/
             MONMSG     MSGID(CPF8351)                                                    /*CFT035*/
                                                                                          /*CFT035*/
/* Clear program message queue and initialise return code            */
             RMVMSG     PGMQ(*SAME) CLEAR(*ALL)
                                                                                          /*CFT035*/
/* Set up general screen fields                                      */                   /*CFT035*/
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&##MRDT)                              /*CFT035*/
             RTVJOBA    JOB(&##JOB)  USER(&##USR)                                         /*CFT035*/
 
/* Check whether CFT035 is switched on                                                    /*CFT035*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CFT035*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CFT035*/
             CHGVAR     VAR(&SAR) VALUE('CFT035')                                         /*CFT035*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CFT035*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CFT035) VALUE('Y'))                                        /*CFT035*/
             IF         COND(&CFT035 *EQ 'Y') THEN(DO)                                    /*CFT035*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CFT040*/
             CHGVAR     VAR(&SAR) VALUE('CFT040')                                         /*CFT040*/
/* Check if CFT040 is switched on */                                                      /*CFT040*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CFT040*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CFT040*/
             CHGVAR     VAR(&CFT040) VALUE('Y')                                           /*CFT040*/
             CHGVAR     VAR(&IN49) VALUE('1')                                             /*CFT040*/
             ENDDO                                                                        /*CFT040*/
/* Display initial screen to get confirmation that user wishes to continue */             /*CFT035*/
                CHGVAR     VAR(&IN50) VALUE('0')                                          /*CFT035*/
                SNDRCVF    RCDFMT(#INIT)                                                  /*CFT035*/
                IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(ENDCLPGM))                /*CFT035*/
/* Retrieve revision date of SWIFT files in QGPL */                                       /*CFT040*/
             CALL       PGM(MEC1461) PARM(&ERRTYP)                                        /*CFT040*/
             IF         COND(&ERRTYP *NE '0') THEN(DO)                                    /*CFT040*/
             IF         COND(&ERRTYP *EQ '1') THEN(CHGVAR +
                        (&IN71) VALUE('1'))                                               /*CFT040*/
             IF         COND(&ERRTYP *EQ '2') THEN(CHGVAR +
                        (&IN72) VALUE('1'))                                               /*CFT040*/
             IF         COND(&ERRTYP *EQ '3') THEN(CHGVAR +
                        (&IN73) VALUE('1'))                                               /*CFT040*/
             IF         COND(&ERRTYP *EQ '4') THEN(CHGVAR +
                        (&IN74) VALUE('1'))                                               /*CFT040*/
             IF         COND(&ERRTYP *EQ '5') THEN(CHGVAR +
                        (&IN75) VALUE('1'))                                               /*CFT040*/
             IF         COND(&ERRTYP *EQ '6') THEN(CHGVAR +
                        (&IN60) VALUE('1'))                                               /*CFT040*/
             GOTO       CMDLBL(ABNOR)                                                     /*CFT040*/
             ENDDO                                                                        /*CFT040*/
                CHKOBJ     OBJ(MEDWFIPD) OBJTYPE(*FILE) MBR(*FIRST)                       /*CFT035*/
                MONMSG     MSGID(CPF9801) EXEC(DO)                                        /*CFT035*/
                   SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('File +
                          MEDWFIPD not found - MEC1420 terminated') +
                          TOMSGQ(MOPERQ)                                                  /*CFT035*/
                   CHGVAR     VAR(&IN60) VALUE('1')                                       /*CFT035*/
                   GOTO CMDLBL(ABNOR)                                                     /*CFT035*/
                ENDDO                                                                     /*CFT035*/
                CHKOBJ     OBJ(MEDWCTPD) OBJTYPE(*FILE) MBR(*FIRST)                       /*CFT035*/
                MONMSG     MSGID(CPF9801) EXEC(DO)                                        /*CFT035*/
                   SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('File +
                          MEDWCTPD not found - MEC1420 terminated') +
                          TOMSGQ(MOPERQ)                                                  /*CFT035*/
                   CHGVAR     VAR(&IN60) VALUE('1')                                       /*CFT035*/
                   GOTO CMDLBL(ABNOR)                                                     /*CFT035*/
                ENDDO                                                                     /*CFT035*/
                CHKOBJ     OBJ(MEDWHDPD) OBJTYPE(*FILE) MBR(*FIRST)                       /*CFT035*/
                MONMSG     MSGID(CPF9801) EXEC(DO)                                        /*CFT035*/
                   SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('File +
                          MEDWHDPD not found - MEC1420 terminated') +
                          TOMSGQ(MOPERQ)                                                  /*CFT035*/
                   CHGVAR     VAR(&IN60) VALUE('1')                                       /*CFT035*/
                   GOTO CMDLBL(ABNOR)                                                     /*CFT035*/
                ENDDO                                                                     /*CFT035*/
                CLRPFM     METICPPD                                                       /*CFT035*/
                CLRPFM     METICCPD                                                       /*CFT035*/
                CLRPFM     METICVPD                                                       /*CFT035*/
                OVRDBF     FILE(MEDWFIPD) TOFILE(MEDWFIPD) LVLCHK(*NO)                    /*CFT035*/
                OVRDBF     FILE(MEDWCTPD) TOFILE(MEDWCTPD) LVLCHK(*NO)                    /*CFT035*/
                OVRDBF     FILE(MEDWHDPD) TOFILE(MEDWHDPD) LVLCHK(*NO)                    /*CFT035*/
/* Display screen to inform user of progress                         */                   /*CFT035*/
                CHGVAR     VAR(&IN50) VALUE('1')                                          /*CFT035*/
                SNDF       RCDFMT(#INIT)                                                  /*CFT035*/
                CALL       PGM(ME1460)                                                    /*CFT035*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                               /*CFT035*/
                   CHGVAR     VAR(&IN61) VALUE('1')                                       /*CFT035*/
                   GOTO       CMDLBL(ABNOR)                                               /*CFT035*/
                ENDDO                                                                     /*CFT035*/
             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)                                  /*CFT040*/
             CHGVAR     VAR(&IN76) VALUE('1')                                             /*CFT040*/
             GOTO       CMDLBL(ABNOR)                                                     /*CFT040*/
             ENDDO                                                                        /*CFT040*/
             IF         COND(%SWITCH(X1XXXXXX)) THEN(DO)                                  /*CFT040*/
             CHGVAR     VAR(&IN77) VALUE('1')                                             /*CFT040*/
             GOTO       CMDLBL(ABNOR)                                                     /*CFT040*/
             ENDDO                                                                        /*CFT040*/
             IF         COND(%SWITCH(XX1XXXXX)) THEN(DO)                                  /*CFT040*/
             CHGVAR     VAR(&IN78) VALUE('1')                                             /*CFT040*/
             GOTO       CMDLBL(ABNOR)                                                     /*CFT040*/
             ENDDO                                                                        /*CFT040*/
                CHGVAR     VAR(&IN56) VALUE('1')                                          /*CFT035*/
             ENDDO                                                                        /*CFT035*/
                                                                                          /*CFT035*/
/* Call the BIC version reader                                       */
             CALL       PGM(MEC1421) PARM(&REL_DAT)
 /***********RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&##MRDT)         */                   /*CFT035*/
 /***********RTVJOBA    JOB(&##JOB)  USER(&##USR)                    */                   /*CFT035*/
/************CHGVAR     VAR(&#1DATE) VALUE(&REL_DAT)                 */                   /*CFT035*/
 
             IF         COND(&REL_DAT *EQ ' ') THEN(DO)
    /* No Data has been read from the S.W.I.F.T release date table   */
 
             SNDF       RCDFMT(#TEXT1)
 LOOP:
             RCVF       RCDFMT(#TEXT1)
             IF         COND(&IN03 *EQ '0') THEN(GOTO CMDLBL(LOOP))
 
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&#1ANSW) VALUE('Y')
             CHGVAR     VAR(&#1DATE) VALUE(&REL_DAT)
             CHGVAR     VAR(&#1DTYP) VALUE('D')                                           /*CFT035*/
             IF         COND(&CFT040 *EQ 'Y') THEN(DO)                                    /*CFT040*/
             CHGVAR     VAR(&#1UBIC) VALUE('Y')                                           /*CFT040*/
             ENDDO                                                                        /*CFT040*/
             SNDRCVF    RCDFMT(#TEXT2)
             IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(ENDCLPGM))
             IF         COND(&CFT035 *EQ 'Y') THEN(DO)                                    /*CFT035*/
/* Delta upload requested */                                                              /*CFT035*/
                IF         COND((&#1DTYP *EQ 'D') *OR (&#1DTYP *EQ +
                          'd')) THEN(DO)                                                  /*CFT035*/
                   IF         COND(&CFT040 *EQ 'Y') THEN(DO)                              /*CFT040*/
                   CHGVAR     VAR(&IN63) VALUE('1')                                       /*CFT040*/
                   ENDDO                                                                  /*CFT040*/
                   ELSE       CMD(DO)                                                     /*CFT040*/
                   CHGVAR     VAR(&IN57) VALUE('1')                                       /*CFT035*/
                   ENDDO                                                                  /*CFT040*/
                   SNDF       RCDFMT(#TEXT2)                                              /*CFT035*/
/* Overide to exclude unchanged (U) records in case the upload control files */           /*CFT035*/
/* are full versions rather than deltas                                      */           /*CFT035*/
                   IF         COND(&CFT040 *EQ 'Y') THEN(DO)                              /*CFT040*/
                   OVRDBF     FILE(METICBPD) TOFILE(METICBL1) MBR(*ALL)                   /*CFT040*/
                   OVRDBF     FILE(METICCPD) TOFILE(METICCL1) MBR(*ALL)                   /*CFT040*/
                   OVRDBF     FILE(METICSPD) TOFILE(METICSL1) MBR(*ALL)                   /*CFT040*/
                   ENDDO                                                                  /*CFT040*/
                   ELSE       CMD(DO)                                                     /*CFT040*/
                   OVRDBF     FILE(METICPPD) TOFILE(METICPL1) MBR(*ALL)                   /*CFT035*/
                   OVRDBF     FILE(METICCPD) TOFILE(METICCL1) MBR(*ALL)                   /*CFT035*/
                   ENDDO                                                                  /*CFT040*/
                   CALL       PGM(ME1470)                                                 /*CFT035*/
                   IF         COND(&CFT040 *EQ 'Y') THEN(DO)                              /*CFT040*/
                   DLTOVR     FILE(METICBPD)                                              /*CFT040*/
                   DLTOVR     FILE(METICSPD)                                              /*CFT040*/
                   ENDDO                                                                  /*CFT040*/
                   ELSE       CMD(DO)                                                     /*CFT040*/
                   DLTOVR     FILE(METICPPD)                                              /*CFT035*/
                   ENDDO                                                                  /*CFT040*/
                   DLTOVR     FILE(METICCPD)                                              /*CFT035*/
                   IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                            /*CFT035*/
                   CHGVAR     VAR(&IN62) VALUE('1')                                       /*CFT035*/
                      GOTO       CMDLBL(ABNOR)                                            /*CFT035*/
                   ENDDO                                                                  /*CFT035*/
                ENDDO                                                                     /*CFT035*/
                IF         COND((&#1DTYP *EQ 'F') *OR (&#1DTYP *EQ +
                          'f')) THEN(DO)                                                  /*CFT040*/
/*********                'F')) THEN(DO) */                                    /*CFT035*/ /*CFT040*/
                   IF         COND(&CFT040 *EQ 'Y') THEN(DO)                              /*CFT040*/
                   CHGVAR     VAR(&IN64) VALUE('1')                                       /*CFT040*/
                   ENDDO                                                                  /*CFT040*/
                   ELSE       CMD(DO)                                                     /*CFT040*/
                   CHGVAR     VAR(&IN58) VALUE('1')                                       /*CFT035*/
                   ENDDO                                                                  /*CFT040*/
                   SNDF       RCDFMT(#TEXT2)                                              /*CFT035*/
                   IF         COND(&CFT040 *EQ 'Y') THEN(DO)                              /*CFT040*/
                   CLRPFM     MEBICPPD                                                    /*262490*/
                   CPYF       FROMFILE(METICBPD) TOFILE(MEBICBPD) +
                          MBROPT(*REPLACE) INCREL((*IF BIFLAG *NE 'D'))                   /*CFT040*/
                   ENDDO                                                                  /*CFT040*/
                   ELSE       CMD(DO)                                                     /*CFT040*/
                   CPYF       FROMFILE(METICPPD) TOFILE(MEBICPPD) +
                          MBROPT(*REPLACE) INCREL((*IF BIFLAG *NE 'D'))                   /*CFT035*/
                   ENDDO                                                                  /*CFT040*/
                   CPYF       FROMFILE(METICCPD) TOFILE(MEBICCPD) +
                          MBROPT(*REPLACE)                                                /*CFT035*/
                   ENDDO                                                                  /*CFT035*/
                ENDDO                                                                     /*CFT035*/
             ELSE       CMD(DO)                                                           /*CFT035*/
             IF         COND(&CFT040 *EQ 'Y') THEN(DO)                                    /*CFT040*/
/* Update BIC Database Plus IBAN table                               */                   /*CFT040*/
             CHGVAR     VAR(&IN66) VALUE('1')                                             /*CFT040*/
             ENDDO                                                                        /*CFT040*/
             ELSE       CMD(DO)                                                           /*CFT040*/
/* Update BIC Database Plus table                                    */
             CHGVAR     VAR(&IN51) VALUE('1')
             ENDDO                                                                        /*CFT040*/
             SNDF       RCDFMT(#TEXT2)
             IF         COND(&CFT040 *EQ 'Y') THEN(DO)                                    /*CFT040*/
             CPYF       FROMFILE(METICBPD) TOFILE(MEBICBPD) +
                          MBROPT(*REPLACE) INCREL((*IF BIFLAG *NE 'D'))                   /*CFT040*/
             CHGVAR     VAR(&IN66) VALUE('0')                                             /*CFT040*/
             ENDDO                                                                        /*CFT040*/
             ELSE       CMD(DO)                                                           /*CFT040*/
             CPYF       FROMFILE(METICPPD) TOFILE(MEBICPPD) +
                          MBROPT(*REPLACE) INCREL((*IF BIFLAG *NE 'D'))
             ENDDO                                                                        /*CFT040*/
/* Update BIC Country table                                          */
             CHGVAR     VAR(&IN51) VALUE('0')
             CHGVAR     VAR(&IN52) VALUE('1')
             SNDF       RCDFMT(#TEXT2)
             CPYF       FROMFILE(METICCPD) TOFILE(MEBICCPD) +
                          MBROPT(*REPLACE)
             ENDDO                                                                        /*CFT035*/
/* Update BIC Database Plus Search Index                             */
             CHGVAR     VAR(&IN57) VALUE('0')                                             /*CFT035*/
             CHGVAR     VAR(&IN58) VALUE('0')                                             /*CFT035*/
             CHGVAR     VAR(&IN63) VALUE('0')                                             /*CFT040*/
             CHGVAR     VAR(&IN64) VALUE('0')                                             /*CFT040*/
             CHGVAR     VAR(&IN66) VALUE('0')                                             /*CFT040*/
             CHGVAR     VAR(&IN52) VALUE('0')
             CHGVAR     VAR(&IN53) VALUE('1')
             SNDF       RCDFMT(#TEXT2)
 
             CLRPFM     FILE(MEBICIPD)
             IF         COND((&#1UBIC *EQ 'Y') *OR (&#1UBIC +
                        *EQ 'y')) THEN(DO)                                                /*CFT040*/
             CHGVAR     VAR(&IN66) VALUE('1')                                             /*CFT040*/
             SNDF       RCDFMT(#TEXT2)                                                    /*CFT040*/
             CALL       PGM(ME1461)                                                       /*CFT040*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CFT040*/
             CHGVAR     VAR(&IN65) VALUE('1')                                             /*CFT040*/
             GOTO       CMDLBL(ABNOR)                                                     /*CFT040*/
             ENDDO                                                                        /*CFT040*/
             CHGVAR     VAR(&IN66) VALUE('0')                                             /*CFT040*/
             ENDDO                                                                        /*CFT040*/
             CPYF       FROMFILE(MEBICBPD) TOFILE(QTEMP/+
                        MEBICBPD) MBROPT(*REPLACE) +
                        CRTFILE(*YES) INCREL((*IF BIFLAG *NE 'D'))                        /*CFT040*/
             CPYF       FROMFILE(QTEMP/MEBICBPD) +
                        TOFILE(MEBICBPD) MBROPT(*REPLACE)                                 /*CFT040*/
             DLTF       FILE(QTEMP/MEBICBPD)                                              /*CFT040*/
             MONMSG     MSGID(CPF0000)                                                    /*CFT040*/
/*    Call the BIC Plus search index creation program                */
             CALL       PGM(ME1430) PARM(&RET_COD)
             CHGVAR     VAR(&IN53) VALUE('0')
/* Update BIC Directory                                              */
/*********   IF         COND(&#1ANSW *EQ 'Y') THEN(DO) */                                 /*CFT040*/
             IF         COND((&#1ANSW *EQ 'Y') *OR (&#1ANSW +
                        *EQ 'y')) THEN(DO)                                                /*CFT040*/
             CHGVAR     VAR(&IN54) VALUE('1')
             SNDF       RCDFMT(#TEXT2)
             CLRPFM     FILE(MEBICDPD)
             MONMSG     MSGID(CPF3130) EXEC(GOTO CMDLBL(ABNOR))                         /*MD024820*/
/*    Call the BIC Directory update program                          */
             CALL       ME1440
             CHGVAR     VAR(&IN54) VALUE('0')
             ENDDO
/* Clear temporary files                                             */
             CLRPFM     METICPPD
             CLRPFM     METICCPD
             CLRPFM     METICVPD
             CLRPFM     METICBPD                                                          /*CFT040*/
             CLRPFM     METICSPD                                                          /*CFT040*/
             CHGVAR     VAR(&IN55) VALUE('1')
             SNDF       RCDFMT(#TEXT2)
 LOOP1:
             RCVF       RCDFMT(#TEXT2)
             IF         COND(&IN03 *EQ '0') THEN(GOTO CMDLBL(LOOP1))
             ENDDO
                                                                                          /*CFT035*/
             GOTO       CMDLBL(ENDCLPGM)                                                  /*CFT035*/
                                                                                          /*CFT035*/
 ABNOR:                                                                                   /*CFT035*/
/*********   CHGJOB     SWS(XXXXXX11) */                                       /*CFT035*/ /*CFT040*/
             CHGJOB     SWS(000XXX11)                                                     /*CFT040*/
             ROLLBACK                                                                     /*CFT035*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CFT035*/
                                                                                          /*CFT035*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MEC1420 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)                                                  /*CFT035*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CFT035*/
/*********   SNDRCVF    RCDFMT(#ERROR) */                                      /*CFT035*/ /*CFT040*/
             SNDF       RCDFMT(#ERROR)                                                    /*CFT040*/
 LOOP2:                                                                                   /*CFT040*/
             RCVF       RCDFMT(#ERROR)                                                    /*CFT040*/
             IF         COND(&IN03 *EQ '0') THEN(GOTO CMDLBL(LOOP2))                      /*CFT040*/
/*********   MONMSG     MSGID(CPF0000 MCH0000) */                              /*CFT035*/ /*CFT040*/
                                                                                          /*CFT035*/
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 
             ENDPGM
