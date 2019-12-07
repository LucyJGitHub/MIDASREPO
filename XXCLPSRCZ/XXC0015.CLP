/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB Omit GLACPHPD in SAVLIB')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       XXC0015 - Midas CB Omit GLACPHPD in SAVLIB                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2013           */
/*                                                                   */
/*       Last Amend No. MD020562           Date 23May13              */
/*       Prev Amend No. ERZ178   *CREATE   Date 15Mar13              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD020562 - Add GLACPHPD omit processing to SCC1711          */
/*       ERZ178 - COB Save Enhancements + MIMIX                      */
/*                                                                   */
/*********************************************************************/
 
/**********  PGM        PARM(&MODLIB &DILIB &SAVF &ACPTH &DTACPR)                       /*MD020562*/
             PGM        PARM(&MODLIB &DILIB &SAVF &ACPTH &DTACPR &CALLPGM)              /*MD020562*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2013')
 
             DCL        VAR(&MODLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SAVF) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ACPTH) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DTACPR) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&GLCSVL) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&SVNAM1) TYPE(*CHAR) LEN(20)
             DCL        VAR(&GL2550) TYPE(*CHAR) LEN(1)
             DCL        VAR(&GL4450) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OMTGHP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CALLPGM) TYPE(*CHAR) LEN(9)                                /*MD020562*/
 
/*/COPY SDCPYSRC,SDSVALDCL */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&OMTGHP) VALUE('N')
             CHGVAR     VAR(&SVNAM1) VALUE('OmitGLACPHPDinSAVLIB')
 
             CALL PGM(AOSVALR0) PARM(&RSVALRTNC +
                                     &SVNAM1 &SVAL1 +
                                     ' ' &SVAL2 +
                                     ' ' &SVAL3 +
                                     ' ' &SVAL4 +
                                     ' ' &SVAL5 +
                                     ' ' &SVAL6 +
                                     ' ' &SVAL7 +
                                     ' ' &SVAL8 +
                                     ' ' &SVAL9 +
                                     ' ' &SVAL10)
 
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&GLCSVL) VALUE(%SST(&SVAL1 1 1))
 
             IF         COND(%SST(&MODLIB 3 5) = 'DMLIB') THEN(DO)
 
/** This is DMLIB save - retrieve status of GLC2550 and GLC4450 **/
 
             CALL       PGM(XXC0017) PARM('GLC2550   ' '00001' &GL2550)
             CALL       PGM(XXC0017) PARM('GLC4450   ' '00001' &GL4450)
 
/** Determine requirement of GLACPHPD save in this COB **/
 
             IF         COND((&GL2550 = 'N') *AND (&GL4450 = 'N')) +
                          THEN(DO)
 
             IF         COND(&GLCSVL = 'Y') THEN(DO)
             CHGVAR     VAR(&OMTGHP) VALUE('Y')
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&OMTGHP) VALUE('N')
             ENDDO
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&OMTGHP) VALUE('N')
             ENDDO
             ENDDO
 
/** Save entire library **/
 
/** If called from SCC001711 SWA Save **/                                               /*MD020562*/
             IF         COND(&CALLPGM = 'SCC001711') THEN(DO)                           /*MD020562*/
 
             IF         COND(&OMTGHP = 'Y') THEN(DO)
             SAVLIB     LIB(&MODLIB) DEV(*SAVF) SAVF(&DILIB/&SAVF) +
                          USEOPTBLK(*NO) CLEAR(*ALL) PRECHK(*YES) +
                          SAVACT(*LIB) SAVACTMSGQ(CBSWAMMQ) +
                          ACCPTH(&ACPTH) DTACPR(&DTACPR) +
                          OMITOBJ((GLACPHPD *FILE)) OUTPUT(*PRINT)
             ENDDO
 
             ELSE       CMD(DO)
             SAVLIB     LIB(&MODLIB) DEV(*SAVF) SAVF(&DILIB/&SAVF) +
                          USEOPTBLK(*NO) CLEAR(*ALL) PRECHK(*YES) +
                          SAVACT(*LIB) SAVACTMSGQ(CBSWAMMQ) +
                          ACCPTH(&ACPTH) DTACPR(&DTACPR) OUTPUT(*PRINT)
             ENDDO
 
             ENDDO                                                                      /*MD020562*/
             ELSE       CMD(DO)                                                         /*MD020562*/
                                                                                        /*MD020562*/
/** If called from SCC1711 Normal Save **/                                              /*MD020562*/
             IF         COND(&OMTGHP = 'Y') THEN(DO)                                    /*MD020562*/
             SAVLIB     LIB(&MODLIB) DEV(*SAVF) SAVF(&DILIB/&SAVF) +
                          USEOPTBLK(*NO) CLEAR(*ALL) PRECHK(*YES) +
                          ACCPTH(&ACPTH) DTACPR(&DTACPR) +
                          OMITOBJ((GLACPHPD *FILE)) OUTPUT(*PRINT)                      /*MD020562*/
             ENDDO                                                                      /*MD020562*/
                                                                                        /*MD020562*/
             ELSE       CMD(DO)                                                         /*MD020562*/
             SAVLIB     LIB(&MODLIB) DEV(*SAVF) SAVF(&DILIB/&SAVF) +
                          USEOPTBLK(*NO) CLEAR(*ALL) PRECHK(*YES) +
                          ACCPTH(&ACPTH) DTACPR(&DTACPR) OUTPUT(*PRINT)                 /*MD020562*/
             ENDDO                                                                      /*MD020562*/
                                                                                        /*MD020562*/
             ENDDO                                                                      /*MD020562*/
 
             GOTO       CMDLBL(ENDPGM)
 
ABNOR:
             SNDPGMMSG  MSG('Save library' *BCAT &MODLIB *BCAT 'to +
                          save file ENDED ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd.')
             ENDPGM
