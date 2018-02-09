/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(SMC000070)   VLDCKR(SMC000070V)  MSGF(UTMSGF)           */
/*EXI    PMTOVRPGM(SMC000070P)                                       */
/*EXI    TEXT('Midas SM Enter release level')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       RELEASELVL - Enter release level                            */
/*                                                                   */
/*       (c) Finastra International Limited 2010                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR875960           Date 20Dec11              */
/*                      BUG27791 *CREATE   Date 26May10              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR875960 - Correction of Release Level to BFMidas 2.0       */
/*       BUG27791 - Identify 'from' release more easily              */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Enter release level')
 
             PARM       KWD(KEYPARM) TYPE(*CHAR) LEN(1) +
                          CONSTANT('X') RSTD(*YES) VALUES('X') +
                          KEYPARM(*YES)
 
/**********  PARM       KWD(PRODUCT) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          VALUES('Midas' 'MidasPlus') MIN(1) +
                          CASE(*MIXED) PROMPT('Product' 1)           */                 /*AR875960*/
 
             PARM       KWD(PRODUCT) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          VALUES('Midas' 'MidasPlus' 'BFMidas') +
                          MIN(1) CASE(*MIXED) PROMPT('Product' 1)                       /*AR875960*/
 
/**********  PARM       KWD(REL) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          VALUES('ABS 10.5' 'ABS 10.6' 'DBA R1' +
                          'DBA R2' 'DBA R3' 'R4' '1.2' '1.2.1' +
                          '1.2T' '1.4') MIN(0) PROMPT('Release')     */                 /*AR875960*/
 
             PARM       KWD(REL) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          VALUES('ABS 10.5' 'ABS 10.6' 'DBA R1' +
                          'DBA R2' 'DBA R3' 'R4' '1.2' '1.2.1' +
                          '1.2T' '1.4' '2.0') MIN(0) PROMPT('Release')
                                                                                        /*AR875960*/
             PARM       KWD(SUBRLS) TYPE(*CHAR) LEN(2) RSTD(*NO) +
                          RANGE(00 20) MIN(0) PROMPT('Sub-release')
 
