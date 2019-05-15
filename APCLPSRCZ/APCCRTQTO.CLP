/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas AP Create QTEMP Objects required by APIs')      */
/*********************************************************************/
/*                                                                   */
/*       Midas    - APIs                                             */
/*                                                                   */
/*       APCCRTQTO - Create QTEMP objects required by the Midas      */
/*                   Transaction APIs.  These include:               */
/*                   - Midas Local Data Area (via another program)   */
/*                   - API DUMP information Data Area                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. 256330             Date 01Sep08              */
/*                      BUG16705A          Date 01Apr08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAP002  *CREATE    Date 24Nov97              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       256330 - API - LEFAMD message transaction causes the        */
/*                APISERVER to dump.  Reverse fix BUC16705A.         */
/*       BUG16705A - The system should automatically generate        */
/*                   customer number if field is blank               */
/*       CAP002 - Conversion of Midas inputs to modular API structure*/
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RETURNCODE)
 
/** Declares                                                         */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/** Return code **/
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10)
 
/*/COPY WNCPYSRC,APH00040                                            */
/** +
    The global monitor sends an escape message, which will end the +
    program instantly if it is executed. +
**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
 
/** +
    Create the required items.       +
**/
             CALL       PGM(ZACCRTLDA) PARM(&RETURNCODE)
             IF         COND(&RETURNCODE *NE ' ') THEN(GOTO +
                          CMDLBL(ABNOR))
 
/**********  CRTDTAARA  DTAARA(QTEMP/APDUMP) TYPE(*CHAR) LEN(256) +                    /*BUG16705A*/
/**********               TEXT('Midas API DUMP Information Data Area')                 /*BUG16705A*/
/**********  CRTDTAARA  DTAARA(QTEMP/APDUMP) TYPE(*CHAR) LEN(274) + */
/**********               TEXT('Midas API DUMP Information Data Area') */   /*BUG16705A*/ /*256330*/
             CRTDTAARA  DTAARA(QTEMP/APDUMP) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas API DUMP Information Data Area')                    /*256330*/
             MONMSG     MSGID(CPF0000)
/*/COPY WNCPYSRC,APH00041                                            */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             RETURN
 
ABNOR:
             CHGVAR     VAR(&RETURNCODE) VALUE('Error')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Error +
                          while creating API QTEMP objects') +
                          MSGTYPE(*ESCAPE)
             ENDPGM
