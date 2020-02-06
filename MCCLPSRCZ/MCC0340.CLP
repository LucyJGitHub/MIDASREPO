/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MC Entry Generation Split')                     */
/********************************************************************/
/*                                                                  */
/*       Midas - Management Accounts Module                         */
/*                                                                  */
/*       MCC0340 - Management Account Entry Generation Split        */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      135682             Date 30Apr99              */
/*                      CMC001 *CREATE     Date 18MAR96             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       135682 - Spot revaluations incorrect if Spot Position      */
/*                is zero. and equivalent is not zero.              */
/*                Change made to pick up zero positions.            */
/*       CMC001 - Created for Management Accounts                   */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&POST)
/**/
             DCL        VAR(&POST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,MCH00004                                            */
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             SNDPGMMSG  MSG('MCC0340 - Management Account Generated +
                          Entry Split') TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(XXXXXX00)
/*/COPY WNCPYSRC,MCH00005                                            */
/**/
/* Clear Ouput files */
/**/
             IF         COND(&POST = '1') THEN(DO)
                 CLRPFM     FILE(GEPCPD)
                 CLRPFM     FILE(GEPCZZ)
                 CPYF       FROMFILE(MCMOVEPD) TOFILE(MCPST1PD) +
                              MBROPT(*REPLACE) FMTOPT(*NOCHK)
                 MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM FILE(MCPST1PD))
             ENDDO
             IF         COND(&POST = '2') THEN(DO)
                 CLRPFM     FILE(GESRPD)
                 CLRPFM     FILE(GESRZZ)
                 CLRPFM     FILE(GEXFPD)
                 CLRPFM     FILE(GEXFZZ)
                 CLRPFM     FILE(GEXBPD)
                 CLRPFM     FILE(GEXBZZ)
                 CLRPFM     FILE(MCPST2PD)
                 CLRPFM     FILE(MCPST3PD)
             ENDDO
             IF         COND(&POST = '3') THEN(DO)
                 CLRPFM     FILE(GEPC2PD)
                 CLRPFM     FILE(GEPC2ZZ)
                 OVRDBF     FILE(GEPCPD) TOFILE(GEPC2PD)
                 OVRDBF     FILE(GEPCZZ) TOFILE(GEPC2ZZ)
                 CPYF       FROMFILE(MCMOVEPD) TOFILE(MCPST1PD) +
                              MBROPT(*REPLACE) FMTOPT(*NOCHK)
                 MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM FILE(MCPST1PD))
             ENDDO
/**/
/*  Summarise Generated Postings */
/**/
/*           OPNQRYF    FILE((MCPCACPD)) GRPFLD(BRCA CCY EVDT PRFC +   135682 */
/*                        ACOD CNUM ACSQ BOKC OTTP OTST ASOC VOIN +    135682 */
/*                        GETP ACSC CPNB ATYP PNAR) GRPSLT('PAMT +     135682 */
/*                        *NE 0') MAPFLD((PAMT '%SUM(1/PAMT)') +       135682 */
/*                        (PDTM '%MAX(1/PDTM)')) ALWCPYDTA(*OPTIMIZE)  135682 */
             OPNQRYF    FILE((MCPCACPD)) GRPFLD(BRCA CCY EVDT PRFC +
                          ACOD CNUM ACSQ BOKC OTTP OTST ASOC VOIN +
                          GETP ACSC CPNB ATYP PNAR) MAPFLD((PAMT +
                          '%SUM(1/PAMT)') (PDTM '%MAX(1/PDTM)') +
                          (ACODQQ 0)) ALWCPYDTA(*OPTIMIZE)                                /*CGL029*/
/**********               '%SUM(1/PAMT)')M(PDTM*'%MAX(1/PDTM)')) +   */                   /*CGL029*/
/**********               ALWCPYDTA(*OPTIMIZE)                       */        /*135682*/ /*CGL029*/
/**/
             CPYFRMQRYF FROMOPNID(MCPCACPD) TOFILE(MCPOSTPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM FILE(MCPOSTPD))
/**/
             CPYF       FROMFILE(MCFREXPD) TOFILE(MCPOSTPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/**/
             CPYF       FROMFILE(MCPCBLPD) TOFILE(MCPOSTPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/**/
/*  Split Management Account Postings */
/**/
             CALL       PGM(MC0340) PARM(&POST)
             DLTOVR     FILE(*ALL)
/*/COPY WNCPYSRC,MCC0340001                                          */
/**/
/*   DATABASE ERROR   */
/**/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
/*  Clear files                */
/**/
             CLRPFM     FILE(MCBLEXPD)
                   MONMSG     MSGID(CPF0000)
/**/
             GOTO       CMDLBL(END)
/**/
/* Abnormal Termination Processing */
/**/
 ABNOR:      SNDPGMMSG  MSG('Management A/c Gen. Entry Split +
                          ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
