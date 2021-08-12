/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME DISABLE STP on Bank Holiday')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management Module                           */
/*                                                                   */
/*       MECP0102 - DISABLE STP on Bank Holiday                      */
/*                                                                   */
/*  Function:  This program calls MEP0102 to check if today is       */
/*             flagged as Bank Holiday. Program MEP0102 returns      */
/*             either OPEN (not bank holiday) or CLOSED (bank        */
/*             holiday). If today is bank holiday then the STP is    */
/*             DISABLED.  It can be started manually using           */
/*             Midas Plus menu options.                              */
/*                                                                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD031937           Date 13Jan15              */
/*       Prev Amend No. AR856737           Date 13Sep11              */
/*                      HVB019  *CREATE    Date 02Dec11              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD031937 - Upgrade STP enhancements to BF Midas 2.1         */
/*       AR856737 - Upgrade STP enhancements to Midas Plus level     */
/*       HVB019 -   DISABLE STP on Bank Holiday                      */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys Banking Systems Ltd. 2011')
/* */
/* Declare variables */
/* */
             DCL        VAR(&HOL_STAT) TYPE(*CHAR) LEN(7) +
                          VALUE('       ')
 
             DCL        VAR(&STP_STAT) TYPE(*CHAR) LEN(5)
/* */
/* Global Monitor Message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
 
             CHGJOB     SWS(XXXXXX00)
 
             RTVDTAARA  DTAARA(MESTPSTAT) RTNVAR(&STP_STAT)
 
 
             CHGVAR     VAR(&HOL_STAT) VALUE('       ')
             CALL MEP0102 PARM(&HOL_STAT)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
 
/*  If today is not a Bank Holiday (bank is open then allow STP to start  */
/*  Restart after disable                                                 */
             IF         COND(&HOL_STAT = '*OPEN  ' *AND &STP_STAT = +
                          'DSBLD') THEN(DO)
             CHGDTAARA  DTAARA(MESTPSTAT) VALUE('STOP')
             GOTO       ENDCLPGM
             ENDDO
 
/*  Normal                                                                */
             IF         COND(&HOL_STAT = '*OPEN  ') THEN(DO)
             GOTO       ENDCLPGM
             ENDDO
 
/*  If today is Bank Holiday (bank is closed) then DISABLE the STP        */
             IF         COND(&HOL_STAT = '*CLOSED') THEN(DO)
/*  End STP if it is running                                              */
             CALL       PGM(MEC1302) PARM('' 'End' ' ')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(MESTPSTAT) VALUE('DSBLD')
             ENDDO
 
             GOTO       ENDCLPGM
 
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             ENDPGM
