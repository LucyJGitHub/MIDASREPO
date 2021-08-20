/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME Change Status of STP Data Area')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management Module                           */
/*                                                                   */
/*       MECP1500 - Midas ME Change Status of STP Data Area          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD031937           Date 13Jan15              */
/*       Prev Amend No. AR856737           Date 13Sep11              */
/*                      HVB019             Date 05Dec11              */
/*                      MKCAR9            Date 22Mar06               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD031937 - Upgrade STP enhancements to BF Midas 2.1         */
/*       AR856737 - Upgrade STP enhancements to Midas Plus level     */
/*       HVB019 -   DISABLE STP on Bank Holiday                      */
/*       MKCAR9 - New dataarea for storing STP status.               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&NEW_STAT)
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys Banking Systems Ltd. 2006')
/* */
/* Declare variables */
/* */
             DCL        VAR(&NEW_STAT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&STP_STAT) TYPE(*CHAR) LEN(5)
/* */
/* Global Monitor Message */
/* */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
 
/* Check if STP is DISABLED due to bank holiday. If DISABLED then do not start STP */   /*HVB019  */
             RTVDTAARA  DTAARA(MESTPSTAT) RTNVAR(&STP_STAT)                             /*HVB019  */
             IF         COND(&STP_STAT = 'DSBLD') THEN(DO)
             SNDPGMMSG  MSG('STP DISABLED - Today is holiday on +
                          PF/BVRHOLPF') TOMSGQ(MOPERQ MRUNQ)                            /*HVB019  */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                  /*HVB019  */
             GOTO       CMDLBL(ENDCLPGM)                                                  /*E00045*/
             ENDDO                                                                        /*E00045*/
 
             IF         COND(&NEW_STAT *EQ 'START') THEN(DO)
               CHGDTAARA DTAARA(MESTPSTAT (1 5)) VALUE('START')
               CALL MEC1304 ('' '' '')
               IF  COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                        CMDLBL(ABNORMAL))
             ENDDO
 
             IF         COND(&NEW_STAT *EQ 'STOP ') THEN(DO)
/*  Close Down FT IMM Job  */
 
               CALL       PGM(MEC1302) PARM('' 'End' ' ')
               IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNORMAL))
               CHGDTAARA DTAARA(MESTPSTAT (1 5)) VALUE('STOP ')
 
             ENDDO
             GOTO       ENDCLPGM
 
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             ENDPGM
