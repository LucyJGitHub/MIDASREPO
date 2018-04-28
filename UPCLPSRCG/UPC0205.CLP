/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas UP Delete logical files')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0205 - Delete Logical Files                              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. A1076141A          Date 23Jan13              */
/*       Prev Amend No. A1076141           Date 11Jan13              */
/*                      CBF012             Date 04Jul11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CUP100             Date 20Jun05              */
/*                      CPK017             Date 02Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP001 *CREATE     Date 06Aug98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       A1076141A- Change back to only having one type of DBU.      */
/*       A1076141 - Change back to only having one type of DBU.      */
/*       CBF012 - BF Infrastructure: Upgradability                   */
/*       CUP100 - Monitor for "Can not delete ..." message.          */
/*       CPK017 - MidasPlus packaging.  Need to read file in         */
/*                descending order.                                  */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&RETURN)  */                                                 /*CBF012*/
/**********  PGM        PARM(&RETURN &MODE)                */              /*CBF012*/ /*AR1076141A*/
             PGM        PARM(&RETURN)                                                 /*AR1076141A*/
 
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&MODE) TYPE(*CHAR) LEN(4)      */              /*CBF012*/ /*AR1076141A*/
 
             DCL        VAR(&USTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/**********  DCLF       FILE(UPDLVCL3)                                                 */ /*CPK017*/
             DCLF       FILE(UPDLVCLA)                                                    /*CPK017*/
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&RETURN) VALUE(' ')
             CHGVAR     VAR(&USTS) VALUE('C')
 
READNEXT:
             IF         COND(&AUMBNM *NE ' ') THEN(DO)
/*/COPY UPCPYSRCG,C_UP0020A                                          */
             ENDDO
 
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
/**********  IF         COND(((&MODE *EQ '*NML') *AND +                */             /*AR1076141A*/
/**********               (%SUBSTRING(&AUSRCF 1 2) *EQ 'HI')) *OR +    */             /*AR1076141A*/
/**********               ((&MODE *EQ '*HIL') *AND +                   */             /*AR1076141A*/
/**********               (%SUBSTRING(&AUSRCF 1 2) *NE 'HI'))) THEN(DO)*/  /*CBF012*/ /*AR1076141A*/
/**********     GOTO       CMDLBL(READNEXT)                            */  /*CBF012*/ /*AR1076141A*/
/**********  ENDDO                                                     */  /*CBF012*/ /*AR1076141A*/
                                                                                          /*CBF012*/
             CHKOBJ     OBJ(&AUMBNM) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(READNEXT))
 
             DLTF       FILE(&AUMBNM)
/**********  MONMSG     MSGID(CPF2105 CPF2189) EXEC(DO)                                */ /*CUP100*/
             MONMSG     MSGID(CPF2105 CPF2189 CPF3219) EXEC(DO)                           /*CUP100*/
                CHGVAR     VAR(&USTS) VALUE('F')
             ENDDO
 
             GOTO       CMDLBL(READNEXT)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGVAR     VAR(&RETURN) VALUE('F')
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
