/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Enter System Id and Set up Library List')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0131 - Enter system id and set up library list           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. CUP033             Date 18Sep06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSM005             Date 21Sep05              */
/*                      CPK019 *CREATE     Date 22Jul04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CPK019 - Prompt to allow for entering a zone prefix and     */
/*                and libraries for the zone is then set up.         */
/*                Parameter &RETURN will be returned with blank if   */
/*                no error.                                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CURSYSID &RETURN)
 
             DCL        VAR(&CURSYSID)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&RETURN)    TYPE(*CHAR) LEN(7)
 
             DCL        VAR(&NEWSYSID)  TYPE(*CHAR) LEN(2)
 
/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*             */ /*CUP033*/
             DCL        VAR(&SVAL) TYPE(*CHAR) LEN(200)                                   /*CUP033*/
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP033*/
             DCL        VAR(&AORTN) TYPE(*CHAR) LEN(7)                                    /*CUP033*/
             DCL        VAR(&RECURSIVE) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
 
/* Prompt for user to enter new system id */
             ?    SYSTEMID
 
/* If F3 to exit the command, set return code to 'EXIT' and end program. */
             MONMSG     MSGID(CPF6801) EXEC(DO)
                CHGVAR     VAR(&RETURN) VALUE('EXIT')
                GOTO       CMDLBL(END)
             ENDDO
 
             RTVDTAARA  DTAARA(QTEMP/SYSID) RTNVAR(&NEWSYSID)
 
             IF         COND(&NEWSYSID *EQ ' ')  THEN(DO)
                CHGVAR     VAR(&RETURN) VALUE('ERROR')
                GOTO       CMDLBL(END)
             ENDDO
 
/* Set up library list for the new zone. */
             CALL       PGM(UPC0014) PARM(&NEWSYSID)
 
/* Get system id &SBSID for the current libraries. */
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*             */ /*CUP033*/
             CALL       PGM(AOSVALR0) PARM(&AORTN +
                          'BrgMidasSystemPrefix' &SVAL ' ' ' ' ' ' +
                          ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' +
                          ' ' ' ' ' ' ' ' ')                                              /*CUP033*/
             IF         COND(&AORTN *NE '       ') THEN(DO)                               /*CUP033*/
                GOTO       CMDLBL(ABNOR)                                                  /*CUP033*/
             ENDDO                                                                        /*CUP033*/
             ELSE       CMD(DO)                                                           /*CUP033*/
                CHGVAR     VAR(&SBSID) VALUE(%SST(&SVAL 1 2))                             /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
/* If library list has not been changed for &NEWSYSID, return with   */
/*    error in &RETURN. */
             IF         COND(&SBSID *NE &NEWSYSID) THEN( +
                   CHGVAR     VAR(&RETURN) VALUE('ERROR'))
             ELSE
/* If library list has been changed successfully, update the current */
/*    zone id. parameter. */
                   CHGVAR     VAR(&CURSYSID) VALUE(&SBSID)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             IF         COND(&RECURSIVE *NE 'Y') THEN(DO)
                CHGVAR     VAR(&RECURSIVE) VALUE('Y')
                CHGVAR     VAR(&RETURN) VALUE('ERROR')
                SNDPGMMSG  MSGID(UPM0002) MSGF(UTMSGF) +
                          MSGDTA('UPC0131') MSGTYPE(*ESCAPE)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
