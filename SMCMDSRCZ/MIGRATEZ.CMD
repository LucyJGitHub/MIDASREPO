/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(SMC000038)  VLDCKR(SMC000037V) MSGF(UTMSGF)             */
/*EXI    ALLOW(*IPGM)                                                */                 /*BUG27793*/
/*EXI *  TEXT('Midas SM Migrate zone')                               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       MIGRATEZ - Migrate zone                                     */
/*                                                                   */
/*       (c) Finastra International Limited 2007                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. BUG27793           Date 04Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      B18716             Date 06May08              */
/*                      CUP038  *CREATE    Date 06Sep07              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG27793 - Make migration muli-streamed..                   */
/*       B18716 - Values are incorrect for MODE.                     */
/*       CUP038 - Re-organise database migration.                    */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Migrate zone database')
 
             PARM       KWD(FROMLIB) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Library to copy data from' 1)
 
             PARM       KWD(TOLIB) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Library to copy data to' 2)
 
/**********  PARM       KWD(MODE) TYPE(*CHAR) LEN(14) RSTD(*YES) +                     */ /*B18716*/
/**********               VALUES(*PREALPHACUST *POSTALPHACUST 8) +                     */ /*B18716*/
/**********               MIN(1) PROMPT('Mode for migration')                          */ /*B18716*/
/**********  PARM       KWD(MODE) TYPE(*CHAR) LEN(14) RSTD(*YES) +                   */ /*BUG27793*/
/**********               VALUES(*PREALPHACUST *POSTALPHACUST) +                     */ /*BUG27793*/
/**********               MIN(1) PROMPT('Mode for migration' 8)           */ /*B18716*/ /*BUG27793*/
 
             PARM       KWD(CRTFILE) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*NO *YES) PROMPT('Create +
                          file if not there?' 3)
 
             PARM       KWD(RERUN) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*NO *YES) PROMPT('Re-run +
                          of copy?' 4)
 
             PARM       KWD(SYSPFX) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*YES) VALUES(*NO *YES) PROMPT('Change +
                          system prefix?' 5)
 
             PARM       KWD(EXCEPTION) TYPE(QUAL1) MIN(0) MAX(20) +
                          PROMPT('Exceptions during copying' 6)
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(0)
             QUAL       TYPE(*CHAR) LEN(8) RSTD(*YES) DFT(*FILE) +
                          VALUES(*FILE *DTAARA *DTAQ) +
                          PROMPT('Object type')
 
/**********  PARM       KWD(EXCPTACT) TYPE(*CHAR) LEN(7) RSTD(*YES) +                */ /*BUG27793*/
/**********               DFT(*SKIP) VALUES(*SKIP *SUBMIT) +                         */ /*BUG27793*/
/**********               PROMPT('Exception action' 7)                               */ /*BUG27793*/
 
/**********  PARM       KWD(JOBQ) TYPE(QUAL2) MIN(0) +                               */ /*BUG27793*/
/**********               PMTCTL(PMTCTL01) PROMPT('Job queue')                       */ /*BUG27793*/
/*QUAL2:***  QUAL       TYPE(*NAME) LEN(10) MIN(0)                                   */ /*BUG27793*/
/**********  QUAL       TYPE(*NAME) LEN(10) RSTD(*NO) DFT(*LIBL) +                   */ /*BUG27793*/
/**********               SPCVAL((*LIBL)) MIN(0) PROMPT('Library')                   */ /*BUG27793*/
/*PMTCTL01:  PMTCTL     CTL(EXCPTACT) COND((*EQ '*SUBMIT'))                          */ /*BUG27793*/
 
/**********  PARM       KWD(THRESHOLD) TYPE(*DEC) LEN(2) DFT(95) +                   */ /*BUG27793*/
/**********               RANGE(01 99) PMTCTL(*PMTRQS) PROMPT('End +                 */ /*BUG27793*/
/**********               copy at system storage %')                                 */ /*BUG27793*/
             PARM       KWD(THRESHOLD) TYPE(*DEC) LEN(2) DFT(95) +
                          RANGE(01 99) PROMPT('End copy at system +
                          storage %')                                                   /*BUG27793*/
 
/**********  PARM       KWD(JUMP) TYPE(*DEC) LEN(2) DFT(1) RANGE(1 +                 */ /*BUG27793*/
/**********               10) PMTCTL(*PMTRQS) PROMPT('End copy if +                  */ /*BUG27793*/
/**********               storage jumps %')                                          */ /*BUG27793*/
             PARM       KWD(JUMP) TYPE(*DEC) LEN(2) DFT(1) RANGE(1 +
                          10) PROMPT('End copy if storage jumps %')                     /*BUG27793*/
 
/**********  PARM       KWD(SBMJOB) TYPE(*CHAR) LEN(4) RSTD(*YES) +                  */ /*BUG27793*/
/**********               DFT(*NO) VALUES(*NO *YES) PMTCTL(*PMTRQS) +                */ /*BUG27793*/
/**********               PROMPT('Submit job ?')                                     */ /*BUG27793*/
 
/**********  PARM       KWD(JOBD) TYPE(*CHAR) LEN(10) MIN(0) +                       */ /*BUG27793*/
/**********               PMTCTL(*PMTRQS) PROMPT('Job description')                  */ /*BUG27793*/
 
