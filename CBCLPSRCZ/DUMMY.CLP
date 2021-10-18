/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB COB Scheduler Menu - COB pgm')               */
/*********************************************************************/
/*                                                                   */
/*       MIDAS - CLOSE OF BUSINESS PROCESSING                        */
/*                                                                   */
/*                                                                   */
/*       DUMMY   - MIDAS CB COB SCHEDULER MENU                       */
/*                                                                   */
/*       (C) MISYS INTERNATIONAL BANKING SYSTEMS LTD. 2012           */
/*                                                                   */
/*       LAST AMEND NO. MD059093           DATE 18OCT21              */
/*       PREV AMEND NO. AR991975           DATE 17JUN12              */
/*                      CCB019  *CREATE    DATE 20MAR12              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*       MD059093 - Deliver AR991975                                 */
/*       AR991975 - MISSING PROGRAM                                  */
/*       AR991975 - MISSING PROGRAM                                  */
/*       CCB019 - CLOSE OF BUSINESS SCHEDULER ENHANCEMENT            */
/*                UPGRADE IPL089                                     */
/*                                                                   */
/*********************************************************************/
            PGM        PARM(&P0 &P1 &P2 &P3 &P4 &P5 &P6 &P7 &P8 &P9 +
                         &R)

            DCL        VAR(&P0) TYPE(*CHAR) LEN(10)
            DCL        VAR(&P1) TYPE(*CHAR) LEN(10)
            DCL        VAR(&P2) TYPE(*CHAR) LEN(10)
            DCL        VAR(&P3) TYPE(*CHAR) LEN(10)
            DCL        VAR(&P4) TYPE(*CHAR) LEN(10)
            DCL        VAR(&P5) TYPE(*CHAR) LEN(10)
            DCL        VAR(&P6) TYPE(*CHAR) LEN(10)
            DCL        VAR(&P7) TYPE(*CHAR) LEN(10)
            DCL        VAR(&P8) TYPE(*CHAR) LEN(10)
            DCL        VAR(&P9) TYPE(*CHAR) LEN(10)
            DCL        VAR(&R) TYPE(*CHAR) LEN(1)

            CHGVAR     VAR(&R) VALUE(' ')


END:        ENDPGM

