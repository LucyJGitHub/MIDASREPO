/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MX End I/C Drip-feed Extrct and Transmission')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0630 - End I/C Drip-Feed Extract and Transmission        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG9619            Date 01Feb06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CMX001  *CREATE    Data 01Jan00              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*       CMX001 - Meridian Export                                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,MXC0630INT                                          */
 
             DCL        VAR(&TREF) TYPE(*CHAR) LEN(20) +
                        VALUE('SHUTDOWN')
             DCL        VAR(&TCAT) TYPE(*CHAR) LEN(4)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,MXC0630MPS                                          */
 
/* Try to allocate MXOLEJPD - if it fails, the drip-feed extract    */
/* job is active, so shut it down.                                  */
 
              ALCOBJ     OBJ((MXOLEJPD *FILE *EXCL)) WAIT(0)
              MONMSG     MSGID(CPF0000) EXEC(DO)
 
 /********** SNDJRNE    JRN(ICJRN) TYPE('XJ') ENTDTA('EXT') + */                         /*BUG9619*/
 /**********              FILE(SDBANKPD) */                                              /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE('XJ') ENTDTA('EXT') +
                          FILE(SDBANKPD) FORCE(*YES)                                     /*BUG9619*/
 
              ENDDO
 
              DLCOBJ     OBJ((MXOLEJPD *FILE *EXCL))
              MONMSG     MSGID(CPF0000)
 
/* Try to allocate MXOLTJPD - if it fails, the drip-feed transmission*/
/* job is active, so shut it down.                                   */
 
              ALCOBJ     OBJ((MXOLTJPD *FILE *EXCL)) WAIT(0)
              MONMSG     MSGID(CPF0000) EXEC(DO)
 
/**********  SNDJRNE    JRN(ICJRN) TYPE('XJ') ENTDTA('TRM') + */                         /*BUG9619*/
/**********               FILE(MXTRIGPD) */                                              /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE('XJ') ENTDTA('TRM') +
                          FILE(MXTRIGPD) FORCE(*YES)                                     /*BUG9619*/
 
              ENDDO
 
              DLCOBJ     OBJ((MXOLTJPD *FILE *EXCL))
              MONMSG     MSGID(CPF0000)
 
/*/COPY WNCPYSRC,MXC0630MPE                                          */
 
            GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,MXC0630ERR                                          */
 
/* Abnormal termination */
 
             CHGJOB     SWS(XXXXXX11)
               ROLLBACK
               MONMSG     MSGID(CPF0000 MCH0000)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0630 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,MXC0630END                                          */
 
ENDPGM
