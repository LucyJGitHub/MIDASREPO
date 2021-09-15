/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME DISABLE STP on Bank Holiday')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management Module                           */
/*                                                                   */
/*       MECP0102 - DISABLE STP on Bank Holiday                      */
/*                                                                   */
/*  Function:  This program ENABLES or DISABLES STP processing.      */
/*             If dataara MESTPSTAT contains 'DSBLD' then program    */
/*             MECP1500 and MEC1304 will not start STP               */
/*                                                                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD031937           Date 13Jan15              */
/*       Prev Amend No. AR856737           Date 13Sep11              */
/*                      HVB019   *CREATE   Date 02Dec11              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD031937 - Upgrade STP enhancements to BF Midas 2.1         */
/*       AR856737 - Upgrade STP enhancements to Midas Plus level     */
/*       HVB019 -   DISABLE STP on Bank Holiday                      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&STATUS)
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys Banking Systems Ltd. 2011')
/* */
/* Declare variables */
/* */
             DCL        VAR(&STATUS) TYPE(*CHAR) LEN(7)

             DCL        VAR(&STP_STAT) TYPE(*CHAR) LEN(5)
/* */
/* Global Monitor Message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)

             CHGJOB     SWS(XXXXXX00)

             RTVDTAARA  DTAARA(MESTPSTAT) RTNVAR(&STP_STAT)

/*  ENABLE STP                                                            */
             IF         COND(&STATUS = 'ENABLE ') THEN(DO)
             CHGDTAARA  DTAARA(MESTPSTAT) VALUE('     ')
             GOTO       ENDCLPGM
             ENDDO

/*  DISABLE STP                                                           */
             IF         COND(&STATUS = 'DISABLE') THEN(DO)
/*  End STP if it is running                                              */
             CALL       PGM(MEC1302) PARM('' 'End' ' ')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(MESTPSTAT) VALUE('DSBLD')
             GOTO       ENDCLPGM
             ENDDO

             GOTO       ENDCLPGM

ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

             ENDPGM
