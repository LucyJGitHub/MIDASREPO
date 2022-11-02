/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('CL Program to call SMU00600A and SMU00600B')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/********UTCDL051*-*CL*Program*to*call*SMU00600A*and*SMU00600B*in*****/                 /*MD060636*/
/*******************AUDIT or UPDATE mode.*****************************/                 /*MD060636*/
/*       SMUC00600 - CL Program to call SMU00600A and SMU00600B      */                 /*MD060636*/
/*                                                                   */
/*       (c) Finastra International Limited 2022                     */
/*                                                                   */
/*       Last Amend No. MD060636           Date 02Nov22              */
/*       Prev Amend No. 255626 *CREATE     Date 25Jul22              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD060636 - ZDBU error in OTB Perf TD System                 */
/*       255626 - Applied fix 242527                                 */
/*       242527 - DL deal amendment is not shown on projected account*/
/*                movements.Applied fix 213349.                      */
/*                Calls SMU00600A and SMU00600B datapatch programs.  */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/**********  PGM PARM(&MODE) */                                                         /*MD060636*/
             PGM                                                                        /*MD060636*/

/**********  DCL        VAR(&MODE) TYPE(*CHAR) LEN(7) */                                /*MD060636*/
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2022')

/**/
/** Global monitor message */
/**/

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/**********  SNDPGMMSG  MSG('UTCDL0051 - Datapatch to correct fields +  */              /*MD060636*/
             SNDPGMMSG  MSG('SMUC00600 - Datapatch to correct fields +
                          DAVD, DASN, NAAD, NASN in PFs DEALSDC and +
                          DEAMSDI') TOMSGQ(MRUNQ MOPERQ)                                /*MD060636*/

/**********  IF         COND((&MODE *NE '*AUDIT') *AND (&MODE *NE +     */              /*MD060636*/
/**********               '*audit') *AND (&MODE *NE '*UPDATE') *AND +   */              /*MD060636*/
/**********               (&MODE *NE '*update')) THEN(DO)               */              /*MD060636*/
/**********     SNDPGMMSG  MSG('Only ''*AUDIT'', ''*audit'', +          */              /*MD060636*/
/**********                 ''*UPDATE'', ''*update'' will be accepted + */              /*MD060636*/
/**********                  as parameters')                            */              /*MD060636*/
/**********     GOTO       CMDLBL(END)                                  */              /*MD060636*/
/**********  ENDDO                                                      */              /*MD060636*/

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(LDA) VALUE(*BLANK)
             CHGJOB     SWS(XXXXXX00)

/**********  IF         COND((&MODE *EQ '*AUDIT') *OR +         */                      /*MD060636*/
/**********               (&MODE *EQ '*audit')) THEN(DO)        */                      /*MD060636*/
/**********     CALL       PGM(SMU00600A) PARM('A')             */                      /*MD060636*/
/**********     IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +  */                      /*MD060636*/
/**********                  CMDLBL(ABNOR))                     */                      /*MD060636*/
/**********     CALL       PGM(SMU00600B) PARM('A')             */                      /*MD060636*/
/**********     IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +  */                      /*MD060636*/
/**********                  CMDLBL(ABNOR))                     */                      /*MD060636*/
/**********  ENDDO                                              */                      /*MD060636*/

/**********  IF         COND((&MODE *EQ '*UPDATE') *OR +        */                      /*MD069636*/
/**********               (&MODE *EQ '*update')) THEN(DO)       */                      /*MD060636*/

/**/
/** Save copies of DEAMSDI and DEALSDC in xxDILIB */
/**/

                RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
                CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
                CHGVAR     VAR(&DILIB) VALUE(&PRE *TCAT 'DILIB')
                CHGVAR     VAR(&DMLIB) VALUE(&PRE *TCAT 'DMLIB')

                CRTDUPOBJ  OBJ(DEALSDC) FROMLIB(&DMLIB) +
                             OBJTYPE(*FILE) TOLIB(&DILIB) +
                             NEWOBJ(DEALSDCBK) DATA(*YES)
                MONMSG     MSGID(CPF2130 CPD2104) EXEC(DO)
                   SNDPGMMSG  MSG('FILE DEALSDCBK already exists.  +
                             Backup not created.') TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(END)
                ENDDO

                CRTDUPOBJ  OBJ(DEAMSDI) FROMLIB(&DMLIB) +
                             OBJTYPE(*FILE) TOLIB(&DILIB) +
                             NEWOBJ(DEAMSDIBK) DATA(*YES)
                MONMSG     MSGID(CPF2130 CPD2104) EXEC(DO)
                   SNDPGMMSG  MSG('FILE DEAMSDIBK already exists.  +
                             Backup not created.') TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(END)
                ENDDO

/**********     CALL       PGM(SMU00600A) PARM('U')                   */                /*MD060636*/
                CALL       PGM(SMU00600A)                                               /*MD060636*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
/**********     CALL       PGM(SMU00600B) PARM('U')                   */                /*MD060636*/
                CALL       PGM(SMU00600B)                                               /*MD060636*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
                DLTF       FILE(&DILIB/DEALSDCBK)
                DLTF       FILE(&DILIB/DEAMSDIBK)
/**********  ENDDO                                                    */                /*MD060636*/

             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                SNDPGMMSG  MSG('Program ended normally.')
                GOTO       CMDLBL(END)
             ENDDO
             GOTO       CMDLBL(END)

 ABNOR:      SNDPGMMSG  MSG('Program ended abnormally, please +
                          contact support desk')
/**********  IF         COND((&MODE *EQ '*UPDATE') *OR +              */                /*MD060636*/
/**********               (&MODE *EQ '*update')) THEN(DO)             */                /*MD060636*/
                CPYF       FROMFILE(&DILIB/DEALSDCBK) +
                             TOFILE(&DMLIB/DEALSDC) MBROPT(*REPLACE) +
                             FMTOPT(*MAP *DROP)
                CPYF       FROMFILE(&DILIB/DEAMSDIBK) +
                             TOFILE(&DMLIB/DEAMSDI) MBROPT(*REPLACE) +
                             FMTOPT(*MAP *DROP)
/**********  ENDDO                                                    */                /*MD060636*/

             DLTF       FILE(&DILIB/DEALSDCBK)
             DLTF       FILE(&DILIB/DEAMSDIBK)

 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2022')
             ENDPGM

