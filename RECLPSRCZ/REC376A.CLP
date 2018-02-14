/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Interest Statement Print RCVF STI')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     Retail Module                                     */
/*                                                                   */
/*       REC376A -  RETAIL INTEREST AND CHARGE GENERATION            */
/*                  RCVF TABTBRE                                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. CRE113             Date 08Feb18              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      AR1069713          Date 14Dec12              */
/*                      259754             Date 27Jul12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CCB016             Date 18Feb08              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01413 *Create     Date 13Apr93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRE113 - COB Optimisation of REC376A                        */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1069713 - Reverse fix 259754                              */
/*       259754 - CoB Performance Enhancements for RZB. Override     */
/*                RECAPM with a result of QPNQRYF, it will force to  */
/*                generate statements for selected range of customers*/
/*                only.                                              */
/*       CCB016 - CoB Performance Enhancements.                      */
/*                Split REC376 and REC376A to allow REC376A to       */
/*                be removed from immediate dependencies.            */
/*                Override ACCNTL1 to EACCNTL1 to prevent locking    */
/*                as a result of call to AOACCTR0.                   */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
/**/
/* THIS PGM USE SECURITY COPY OF FILES INSTEAD OF JOURNALING */
/**/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RECAPM) TYPE(*DEC) LEN(10 0)                                 /*CCB016*/
/**********  DCL        VAR(&QRYSLT) TYPE(*CHAR) LEN(2000)         */           /*259754 AR1069713*/
/**********                                                        */           /*259754 AR1069713*/
/**DECLARE*PARAMETERS*TO*AOSVALR0**/                                            /*259754 AR1069713*/
/**********                                                        */           /*259754 AR1069713*/
/**********  DCL        VAR(&REC376A) TYPE(*CHAR) LEN(1) VALUE('N')*/           /*259754 AR1069713*/
/**********  DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE('       +
                          ')                                       */           /*259754 AR1069713*/
/**********  DCL        VAR(&POP01) TYPE(*CHAR) LEN(20) +
                          VALUE('OPTIMISEREC376A')                 */           /*259754 AR1069713*/
/**********  DCL        VAR(&POP02) TYPE(*CHAR) LEN(20)            */           /*259754 AR1069713*/
/**********  DCL        VAR(&POP03) TYPE(*CHAR) LEN(20)            */           /*259754 AR1069713*/
/**********  DCL        VAR(&POP04) TYPE(*CHAR) LEN(20)            */           /*259754 AR1069713*/
/**********  DCL        VAR(&POP05) TYPE(*CHAR) LEN(20)            */           /*259754 AR1069713*/
/**********  DCL        VAR(&POP06) TYPE(*CHAR) LEN(20)            */           /*259754 AR1069713*/
/**********  DCL        VAR(&POP07) TYPE(*CHAR) LEN(20)            */           /*259754 AR1069713*/
/**********  DCL        VAR(&POP08) TYPE(*CHAR) LEN(20)            */           /*259754 AR1069713*/
/**********  DCL        VAR(&POP09) TYPE(*CHAR) LEN(20)            */           /*259754 AR1069713*/
/**********  DCL        VAR(&POP10) TYPE(*CHAR) LEN(20)            */           /*259754 AR1069713*/
/**********  DCL        VAR(&PVL01) TYPE(*CHAR) LEN(200)           */           /*259754 AR1069713*/
/**********  DCL        VAR(&PVL02) TYPE(*CHAR) LEN(200)           */           /*259754 AR1069713*/
/**********  DCL        VAR(&PVL03) TYPE(*CHAR) LEN(200)           */           /*259754 AR1069713*/
/**********  DCL        VAR(&PVL04) TYPE(*CHAR) LEN(200)           */           /*259754 AR1069713*/
/**********  DCL        VAR(&PVL05) TYPE(*CHAR) LEN(200)           */           /*259754 AR1069713*/
/**********  DCL        VAR(&PVL06) TYPE(*CHAR) LEN(200)           */           /*259754 AR1069713*/
/**********  DCL        VAR(&PVL07) TYPE(*CHAR) LEN(200)           */           /*259754 AR1069713*/
/**********  DCL        VAR(&PVL08) TYPE(*CHAR) LEN(200)           */           /*259754 AR1069713*/
/**********  DCL        VAR(&PVL09) TYPE(*CHAR) LEN(200)           */           /*259754 AR1069713*/
/**********  DCL        VAR(&PVL10) TYPE(*CHAR) LEN(200)           */           /*259754 AR1069713*/
             DCL        VAR(&QRYSLT) TYPE(*CHAR) LEN(2000)                                /*CRE113*/
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(10 0)                                  /*CRE113*/
                                                                                          /*CRE113*/
             DCLF       FILE(TABTBRE)
/**/
             SNDPGMMSG  MSG('REC376 - Retail interests statements  ') +
                          TOMSGQ(MRUNQ)
/**********                                                        */           /*259754 AR1069713*/
/**CHECK*SYSTEM*VALUE*OPTIMISEREC376A*IS*ON**/                                  /*259754 AR1069713*/
/**********                                                        */           /*259754 AR1069713*/
/**********  CALL       PGM(AOSVALR0) PARM(&PRTCD &POP01 &PVL01 +
                          &POP02 &PVL02 &POP03 &PVL03 &POP04 &PVL04 +
                          &POP05 &PVL05 &POP06 &PVL06 &POP07 &PVL07 +
                          &POP08 &PVL08 &POP09 &PVL09 &POP10 &PVL10)*/          /*259754 AR1069713*/
/**********  IF         COND(&PRTCD *EQ '       ') THEN(DO)        */           /*259754 AR1069713*/
/**********    CHGVAR     VAR(&REC376A) VALUE(%SUBSTRING(&PVL01 1 1))*/         /*259754 AR1069713*/
/**********  ENDDO                                                 */           /*259754 AR1069713*/
/**********  ELSE       CMD(DO)                                   */            /*259754 AR1069713*/
/**********    CHGVAR     VAR(&REC376A) VALUE('N')                */            /*259754 AR1069713*/
/**********  ENDDO                                                */            /*259754 AR1069713*/
/**********                                                       */            /*259754 AR1069713*/
/**/
/*  FOLLOWING CHECK IS DONE TO AVOID RUN OF PROGRAM IF NO CHARGE    */
/*  PROCESSING IS REQUIRED : FILE TABTBRE IS EMPTY                  */
/**/
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
              SNDPGMMSG  MSG('Record not found in file : TABTBRE by +
                          PGM : REC376A') TOMSGQ(MOPERQ MRUNQ)
              CHGJOB SWS(XXXXXX11)
              GOTO       CMDLBL(ENDCL)
             ENDDO
 
/* Check if RECAPM has any records before continuing (as per REC376) */                   /*CCB016*/
                                                                                          /*CCB016*/
             RTVMBRD    FILE(RECAPM) NBRCURRCD(&RECAPM)                                   /*CCB016*/
             IF         COND(&RECAPM = 0) THEN(GOTO CMDLBL(ENDCL))                        /*CCB016*/
                                                                                          /*CCB016*/
             OVRDBF     FILE(ACCNTL0) TOFILE(EACCNTL0)                                    /*CCB016*/
             OVRDBF     FILE(ACCNTL1) TOFILE(EACCNTL1)                                    /*CCB016*/
/**********  IF         COND(&REC376A *EQ 'Y') THEN(DO)            */           /*259754 AR1069713*/
/**********  RTVDTAARA  DTAARA(REC376A (1 2000)) RTNVAR(&QRYSLT)   */           /*259754 AR1069713*/
/**********                                                        */           /*259754 AR1069713*/
/**********  OVRDBF     FILE(RECAPML) TOFILE(RECAPML) SECURE(*YES) SHARE(*YES)  /*259754 AR1069713*/
/**********                                                        */           /*259754 AR1069713*/
/**********  OPNQRYF    FILE((RECAPML)) OPTION(*INP) FORMAT(*FILE) +
                          QRYSLT(&QRYSLT) +
                          KEYFLD(*FILE) OPNID(RECAPMLQRY) SEQONLY(*NO)*/        /*259754 AR1069713*/
/**********                                                        */           /*259754 AR1069713*/
/**********  ENDDO                                                 */           /*259754 AR1069713*/
/**********                                                        */           /*259754 AR1069713*/
/*/COPY WNCPYSRC,REC376A001                                          */

/* Check if Customer Ranges has been defined, skip if no records                          /*CRE113*/
                                                                                          /*CRE113*/
             RTVMBRD    FILE(SDCUSRTD) NBRCURRCD(&COUNT)                                  /*CRE113*/
                                                                                          /*CRE113*/
             IF         COND(&COUNT > 0) THEN(DO)                                         /*CRE113*/
             CALL       PGM(RE001591) PARM(&QRYSLT)                                       /*CRE113*/
                                                                                          /*CRE113*/
             OVRDBF     FILE(RECAPML) TOFILE(RECAPML) SECURE(*YES) SHARE(*YES)            /*CRE113*/
                                                                                          /*CRE113*/
             OPNQRYF    FILE((RECAPML)) OPTION(*INP) FORMAT(*FILE) +
                          QRYSLT(&QRYSLT) +
                          KEYFLD(*FILE) OPNID(RECAPMLQRY) SEQONLY(*NO)                    /*CRE113*/
             ENDDO                                                                        /*CRE113*/

             IF         COND((&ISTS *EQ '1') *OR (&ISTS *EQ ' ')) +
                          THEN(CALL REC3761)
             IF         COND(&ISTS *EQ '2') THEN(CALL REC3762)
             IF         COND(&ISTS *EQ '3') THEN(CALL REC3763)
             IF         COND(&ISTS *EQ '5') THEN(CALL REC3765)
/**********                                                        */           /*259754 AR1069713*/
/**********  IF         COND(&REC376A *EQ 'Y') THEN(DO)            */           /*259754 AR1069713*/
/**********  CLOF       OPNID(RECAPMLQRY)                          */           /*259754 AR1069713*/
/**********  DLTOVR     FILE(RECAPML)                              */           /*259754 AR1069713*/
/**********  ENDDO                                                 */           /*259754 AR1069713*/

             IF         COND(&COUNT > 0) THEN(DO)                                         /*CRE113*/
             CLOF       OPNID(RECAPMLQRY)                                                 /*CRE113*/
             DLTOVR     FILE(RECAPML)                                                     /*CRE113*/
             ENDDO                                                                        /*CRE113*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDCL:       ENDPGM
