/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ME MT94x Production on Request')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Messages Management Module                          */
/*                                                                   */
/*       MEC0050 - Midas ME MT94x Production on Request Maintenance  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/*       Last Amend No. MD023522          Date 21Nov13               */
/*       Prev Amend No. CGL146A           Date 10Jul13               */
/* Bank Fusion Midas 2.1 Base ---------------------------------------*/
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CGL013  *CREATE   Date 07May02               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD023522 - Various line for one account is shown in         */
/*                  in MT940/950 Production on Request (Recompile)   */
/*       CGL146A - MT940/MT950 Production in Input Cycle             */
/*       CGL013 - MT94x Messages Generation                          */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RTCD)
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
/*/COPY OFCPYSRCZ,CGL146_108                                         */                  /*CGL146A*/
/*/COPY OFCPYSRCZ,CGL146_103                                         */                  /*CGL146A*/
 
             CHGJOB SWS(XXXXXX00)
/*/COPY OFCPYSRCZ,CGL146_109                                         */                  /*CGL146A*/
/*/COPY OFCPYSRCZ,CGL146_104                                         */                  /*CGL146A*/
/** Call program & monitor for untrapped errors **/
             CALL       PGM(ME000050)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
                SNDPGMMSG  MSG('Transaction Failed. Re-input necessary. +
                             Press Enter to Continue.') TOPGMQ(*EXT)
                ROLLBACK
                GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY OFCPYSRCZ,CGL146_105                                         */                  /*CGL146A*/
 
/** Database error handling   **/
 
             IF   COND(%SWITCH(XXXXXX11)) +
               THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&Mem)
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&Mem) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                 ROLLBACK
               ENDDO
 
 
 END:        RCLRSC
             RCLACTGRP  ACTGRP(QILE)
             MONMSG     MSGID(CPF1653)
 
/*/COPY OFCPYSRCZ,CGL146_106                                         */                  /*CGL146A*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             RETURN
             ENDPGM
