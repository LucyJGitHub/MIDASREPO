/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas UP OTU handle existing lib for move')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       UPC03526 - OTU handle existing libraries for move           */
/*                                                                   */
/*       Function: This program performs the simila tasks as UPC0352 */
/*                 without prompting for answer.                     */
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
/**********  PGM        PARM(&MOVLIB &RETURN) */                                        /*MD058953*/
             PGM        PARM(&MOVLIB &RETURN &BRGBRGLIB &BRGDTALIB)                     /*MD058953*/

             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MOVLIB) TYPE(*CHAR) LEN(10)

             DCL        VAR(&REPLY1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&BRGBRGLIB) TYPE(*CHAR) LEN(10)                             /*MD058953*/
             DCL        VAR(&BRGDTALIB) TYPE(*CHAR) LEN(10)                             /*MD058953*/
             DCL        VAR(&SAVF) TYPE(*CHAR) LEN(10) VALUE('DDS_OLD')                 /*MD058953*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(10)                                  /*MD058953*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')

/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             CHGJOB     SWS(XXXXXX00)

/* If library already exists then ask user what is required */
CHOOSE:
             CHGVAR     VAR(&REPLY1) VALUE('D')
             IF         COND(&REPLY1 *EQ 'D') THEN(DO)
/* save files that will be used for DDS data take-on */                                 /*MD058953*/
                DLTF       FILE(&BRGBRGLIB/&SAVF)                                       /*MD058953*/
                MONMSG     MSGID(CPF2105)                                               /*MD058953*/
                CRTSAVF    FILE(&BRGBRGLIB/&SAVF)                                       /*MD058953*/
                CALL       PGM(UP0352) PARM(&MOVLIB &BRGBRGLIB &SAVF &BRGDTALIB +
                            &RTCD)                                                      /*MD058953*/
                IF         COND(&RTCD *EQ '*ERROR') THEN(GOTO ABNOR)                    /*MD058953*/
                                                                                        /*MD058953*/
                CLRLIB     LIB(&MOVLIB)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
/* restore files that will be used for DDS data take-on */                              /*MD058953*/
                IF         COND(&RTCD *NE '*NONE') THEN(DO)                             /*MD058953*/
                RSTOBJ     OBJ(*ALL) SAVLIB(&MOVLIB) DEV(*SAVF) +
                          SAVF(&BRGBRGLIB/&SAVF)                                        /*MD058953*/
                ENDDO                                                                   /*MD058953*/
                                                                                        /*MD058953*/
                CHGDTAARA  DTAARA(MIDASMSG *ALL) VALUE(' ')
             ENDDO
             IF         COND(&REPLY1 *EQ 'C') THEN(DO)
                CHGDTAARA  DTAARA(MIDASMSG *ALL) VALUE(' ')
                CHGVAR     VAR(&RETURN) VALUE('C')
                GOTO       CMDLBL(END)
             ENDDO
/* If not one of the options then redisplay screen with message */
             IF         COND(&REPLY1 *NE 'D' *AND &REPLY1 *NE 'I' +
                          *AND &REPLY1 *NE 'C') THEN(DO)
                RTVMSG     MSGID(UPM0012) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (551 50)) VALUE(&MESSAGE)
                GOTO       CMDLBL(CHOOSE)
             ENDDO

             GOTO       CMDLBL(END)
 ABNOR:
             CHGVAR     VAR(&RETURN) VALUE('F')

END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

             ENDPGM
