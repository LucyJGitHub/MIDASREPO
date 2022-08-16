/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas UP OTU CPYSRC validity checker')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       UPC2035_V6 - OTU CPYSRC validity checker                    */
/*                                                                   */
/*       Function: This program performs the validity check          */
/*                 similar to UP2035_V                               */
/*                                                                   */
/*       (c) Finastra International Limited 2022                     */
/*                                                                   */
/*       Last Amend No. CUP044   *CREATE   Date 22May22              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP044 - One Touch Bridge Automation Changes - Release/     */
/*                Patch Upgrade                                      */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&TOLIB)                                                   */ /*CPK016*/
/**********  PGM        PARM(&FROMLIB &TOLIB)                               */ /*CPK016*/ /*CPK018*/
             PGM        PARM(&FROMLIB &TOLIB &LAYER)                                      /*CPK018*/

             DCL        VAR(&FROMLIB) TYPE(*CHAR) LEN(10)                                 /*CPK016*/
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LAYER) TYPE(*CHAR) LEN(7)                                    /*CPK018*/
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')

/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* See if FROMLIB exists */                                                               /*CPK016*/
             CHKOBJ     OBJ(*LIBL/&FROMLIB) OBJTYPE(*LIB)                                 /*CPK016*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                           /*CPK016*/
                GOTO       CMDLBL(ABNOR)                                                  /*CPK016*/
             ENDDO                                                                        /*CPK016*/

/* See if TOLIB exists */
             CHKOBJ     OBJ(*LIBL/&TOLIB) OBJTYPE(*LIB)
             MONMSG     MSGID(CPF9801) EXEC(DO)
/************   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +                              */ /*CPK016*/
/************             MSGDTA('0000Library does not exist') +                       */ /*CPK016*/
/************             MSGTYPE(*DIAG)                                               */ /*CPK016*/
                GOTO       CMDLBL(ABNOR)
             ENDDO

             GOTO       CMDLBL(END)

/*  SEND MESSAGE TO CAUSE CPF TO PASS EARLIER MESSAGES BACK         */
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             DMPCLPGM

END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
