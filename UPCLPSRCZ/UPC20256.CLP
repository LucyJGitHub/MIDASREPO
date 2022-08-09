/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas UP OTU COB validation')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       UPC20256 - OTU COB validation                               */
/*                                                                   */
/*       Function: This program performs the COB validation similar  */
/*                 to UPC2025.                                       */
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
/**********  PGM                                                                       */ /*CUP033*/
             PGM        PARM(&PFXSVAL)                                                    /*CUP033*/

             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*             */ /*CUP033*/
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')

/**********  DCLF       FILE(UPSVALJ0) */                                      /*CUP033* *MD054605*/
             DCLF       FILE(UPSVALJ0) ALWNULL(*YES)                                    /*MD054605*/

/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             CHGJOB     SWS(XXXXXX00)

/* Create data area /MIDASMSG in QTEMP */
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')

/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*             */ /*CUP033*/
/* Check if System Values have been entered. */
/**********  IF         COND(&SBSID *EQ ' ') THEN(DO)                                  */ /*CUP033*/

VALIDATE:                                                                                 /*CUP033*/
             RCVF                                                                         /*CUP033*/
             MONMSG     MSGID(CPF0864) EXEC(DO)                                           /*CUP033*/
                GOTO       CMDLBL(CHECK)                                                  /*CUP033*/
             ENDDO                                                                        /*CUP033*/

             IF         COND(&GISVAL *EQ &PFXSVAL) THEN(DO)                               /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&SBSID) VALUE(&GIVAL)                                   /*CUP033*/
                ENDDO                                                                     /*CUP033*/
/**********     GOTO       CMDLBL(CHECK)                                    */ /*CUP033*/ /*CPK029*/
             ENDDO                                                                        /*CUP033*/

             GOTO       CMDLBL(VALIDATE)                                                  /*CUP033*/

 CHECK:                                                                                   /*CUP033*/
             IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)                                 /*CUP033*/
/* Set up messages for Midas Information Screen  */
                RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)
                CALL       PGM(SCC0010) PARM('UPC2025' 'ENTER' ' ')
                GOTO       CMDLBL(END)
             ENDDO

/* Set up library list */
             CALL       PGM(UPC0014) PARM(&SBSID)

/**********  CHGVAR     VAR(&LIB) VALUE(&SBSID *TCAT 'DTALIB') */                       /*MD055891*/
             CHGVAR     VAR(&LIB) VALUE(&SBSID *TCAT 'DVLIB')                           /*MD055891*/

             CALL       PGM(UPC0020) PARM(&LIB)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO

             GOTO       CMDLBL(END)
 ABNOR:
/* Set up messages for Midas Information Screen  */
             CHGJOB     SWS(XXXXXX11)
             DMPCLPGM
                GOTO       CMDLBL(END)

END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
