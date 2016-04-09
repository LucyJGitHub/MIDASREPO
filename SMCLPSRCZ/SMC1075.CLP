/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SM Prompt for new Midas user name')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC1075 - Allow entry of user name                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. CUP034A            Date 02Nov07              */
/*       Prev Amend No. CUP034 *REDUNDANT  Date 21Dec06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSD013 *CREATE     Date 01Apr03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP034A - THis program was incorrectly made redundant.      */
/*       CUP034 - MidasPlus user data migration.                     */
/*       CSD013 - Midas users data maintenance                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&USRNM &USRTXT)
 
             DCL        VAR(&USRNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USRTXT) TYPE(*CHAR) LEN(25)
 
             DCL        VAR(&REPLY1) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
ENTERUSR:
             CHGVAR     VAR(&USRNM) VALUE(' ')
             CHGVAR     VAR(&USRTXT) VALUE(' ')
             ?          USERNAME
             MONMSG     MSGID(CPF6801) EXEC(DO)
                GOTO       CMDLBL(ENDPGM)
             ENDDO
             RTVDTAARA  DTAARA(QTEMP/USERNAME (1 10)) RTNVAR(&USRNM)
             RTVDTAARA  DTAARA(QTEMP/USERNAME (11 25)) RTNVAR(&USRTXT)
 
             CHKOBJ     OBJ(*LIBL/&USRNM) OBJTYPE(*USRPRF)
/* If username does not exist then send message to confirm still copy. */
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CHGDTAARA  DTAARA(MIDASMSG (101 70)) VALUE('The user +
                             profile' *BCAT &USRNM *BCAT 'does not +
                             exist.')
                CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Do you wish +
                             to copy to this user?')
                CALL       PGM(SCC0010) PARM('SMC1075' 'OPTION' &REPLY1)
                IF         COND(&REPLY1 *EQ 'N') THEN(DO)
                   GOTO       CMDLBL(ENTERUSR)
                ENDDO
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
/* Abnormal program end. */
ABNOR:
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('SMC1075') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('SMC1075' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000)
 
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
