/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB Submit I/C Jobs')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC4009 - Midas CB Submit I/C Jobs                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2012           */
/*                                                                   */
/*       Last Amend No. CCB019  *CREATE    Date 20Mar12              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CCB019 - Close of business Scheduler Enhancement            */
/*                Upgrade IPL089                                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&NAM &SEQ &T)

             DCL        VAR(&T) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&NAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&R) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)
             IF         COND(&TIME *GT &T) THEN(DO)

             SBMJOB     CMD(CALL PGM(CB4001) PARM(&SEQ &R)) +
                          JOB(&NAM) SCDTIME(*CURRENT)
             MONMSG     MSGID(CPF0000)
             ENDDO

             IF         COND(&TIME *LT &T) THEN(DO)
             SBMJOB     CMD(CALL PGM(CB4001) PARM(&SEQ &R)) +
                          JOB(&NAM) SCDTIME(&T)
             MONMSG     MSGID(CPF0000)
             ENDDO

             ENDPGM
