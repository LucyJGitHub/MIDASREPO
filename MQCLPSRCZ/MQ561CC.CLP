/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MQ Open query file for RTMANAGE')               */
/********************************************************************/
/*                                                                  */
/*   Midas  MidasQ MODULE                                   */
/*                                                                  */
/*   MQ561CC - OPEN QUERY FILE SELECTION CRITERIA FOR RTMANAGE      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   LAST AMEND NO. S01419              DATE 17MAY93                */
/*                                                                  */
/********************************************************************/
/*     S01419 - CREATED FOR RTMANAGE SUBSET                         */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&TPR#UR &SELECT)
/**/
             DCL        VAR(&TPR#UR) TYPE(*CHAR) LEN(500)
             DCL        VAR(&SELECT) TYPE(*CHAR) LEN(234)
             DCL        VAR(&FLD1) TYPE(*CHAR) LEN(4)  /* HBACCD */
             DCL        VAR(&FLD2) TYPE(*CHAR) LEN(3)  /* HBCYCD */
             DCL        VAR(&FLD3) TYPE(*CHAR) LEN(3)  /* HBBRCD */
             DCL        VAR(&FLD4) TYPE(*CHAR) LEN(6)  /* HBCUST */
             DCL        VAR(&FLD5) TYPE(*CHAR) LEN(2)  /* HBACSN */
             DCL        VAR(&FLD6) TYPE(*CHAR) LEN(4)  /* HBPCCD */
             DCL        VAR(&FLD7) TYPE(*CHAR) LEN(2)  /* HBBKCD */
             DCL        VAR(&FLD8) TYPE(*CHAR) LEN(10)  /* HBOTTP */
             DCL        VAR(&FLD9) TYPE(*CHAR) LEN(10)  /* HBTSTY */
             DCL        VAR(&FLD0) TYPE(*CHAR) LEN(6)  /* HBACNB */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             CHGVAR     VAR(&FLD1) VALUE(%SST(&TPR#UR 3 4))
             CHGVAR     VAR(&FLD2) VALUE(%SST(&TPR#UR 7 3))
             CHGVAR     VAR(&FLD3) VALUE(%SST(&TPR#UR 10 3))
             CHGVAR     VAR(&FLD4) VALUE(%SST(&TPR#UR 13 6))
             CHGVAR     VAR(&FLD5) VALUE(%SST(&TPR#UR 19 2))
             CHGVAR     VAR(&FLD6) VALUE(%SST(&TPR#UR 21 4))
             CHGVAR     VAR(&FLD7) VALUE(%SST(&TPR#UR 25 2))
             CHGVAR     VAR(&FLD8) VALUE(%SST(&TPR#UR 27 10))
             CHGVAR     VAR(&FLD9) VALUE(%SST(&TPR#UR 37 10))
             CHGVAR     VAR(&FLD0) VALUE(%SST(&TPR#UR 47 6))
/**/
             CHGVAR     VAR(%SST(&SELECT 1 234)) VALUE('HBACCD *EQ +
                          "    " *AND HBCYCD *EQ "   " *AND HBBRCD +
                          *EQ "   " *AND HBCUST *EQ "      " *AND +
                          HBACSN *EQ "  " *AND HBPCCD *EQ "    " +
                          *AND HBBKCD *EQ "  " *AND HBOTTP *EQ +
                          "          " *AND HBTSTY *EQ "          " +
                          *AND HBACNB *EQ "      "')
/**/
             IF         COND(&FLD1 *NE '    ' *AND &FLD1 *NE 'NA') THEN+
                        (CHGVAR  VAR(%SST(&SELECT 13 4)) VALUE(&FLD1))
 
             ELSE       CHGVAR  VAR(%SST(&SELECT 1 22)) +
                          VALUE('                    ')
 
/**/
             IF         COND(&FLD2 *NE '   ' *AND &FLD2 *NE 'NA') THEN+
                        (CHGVAR  VAR(%SST(&SELECT 36 3)) VALUE(&FLD2))
 
             ELSE      CHGVAR  VAR(%SST(&SELECT 24 21)) +
                          VALUE('                   ')
/**/
             IF         COND(&FLD3 *NE '   ' *AND &FLD3 *NE 'NA') THEN+
                        (CHGVAR  VAR(%SST(&SELECT 58 3)) VALUE(&FLD3))
 
             ELSE       CHGVAR  VAR(%SST(&SELECT 46 21)) +
                          VALUE('                   ')
 
/**/
             IF         COND(&FLD4 *NE '      ') THEN+
                        (CHGVAR  VAR(%SST(&SELECT 80 6)) VALUE(&FLD4))
 
             ELSE       CHGVAR  VAR(%SST(&SELECT 68 24)) +
                          VALUE('                      ')
 
/**/
             IF         COND(&FLD5 *NE '  ' *AND &FLD5 *NE 'NA') THEN+
                        (CHGVAR  VAR(%SST(&SELECT 105 2)) VALUE(&FLD5))
 
             ELSE       CHGVAR  VAR(%SST(&SELECT 93 20)) +
                          VALUE('                  ')
 
/**/
             IF         COND(&FLD6 *NE '    ' *AND &FLD6 *NE 'NA') THEN+
                        (CHGVAR  VAR(%SST(&SELECT 126 4)) VALUE(&FLD6))
 
             ELSE       CHGVAR  VAR(%SST(&SELECT 114 22)) +
                          VALUE('                    ')
 
/**/
             IF         COND(&FLD7 *NE '  ' *AND &FLD7 *NE 'NA') THEN+
                        (CHGVAR  VAR(%SST(&SELECT 149 2)) VALUE(&FLD7))
 
             ELSE       CHGVAR  VAR(%SST(&SELECT 137 20)) +
                          VALUE('                 ')
/**/
             IF         COND(&FLD8 *NE '          ' *AND &FLD8 *NE +
                          'NA') THEN(CHGVAR VAR(%SST(&SELECT 170 +
                          10)) VALUE(&FLD8))
 
             ELSE       CHGVAR  VAR(%SST(&SELECT 158 28)) +
                          VALUE('                  ')
/**/
             IF         COND(&FLD9 *NE '          ' *AND &FLD9 *NE +
                          'NA') THEN(CHGVAR VAR(%SST(&SELECT 199 +
                          10)) VALUE(&FLD9))
 
             ELSE       CHGVAR  VAR(%SST(&SELECT 187 28)) +
                          VALUE('                  ')
/**/
             IF         COND(&FLD0 *NE '      ') THEN+
                        (CHGVAR  VAR(%SST(&SELECT 228 6)) VALUE(&FLD0))
 
             ELSE       CHGVAR  VAR(%SST(&SELECT 216 19)) +
                          VALUE('                 ')
/**/
             IF         COND(&FLD0 *NE '      ') THEN(GOTO END)
/**/
             IF         COND(&FLD9 *NE '  ' *AND &FLD9 *NE 'NA') THEN(DO)
                        CHGVAR  VAR(%SST(&SELECT 211 4)) VALUE('    ')
                        GOTO     END
                        ENDDO
/**/
             IF         COND(&FLD8 *NE '  ' *AND &FLD8 *NE 'NA') THEN(DO)
                        CHGVAR  VAR(%SST(&SELECT 182 4)) VALUE('    ')
                        GOTO     END
                        ENDDO
/**/
             IF         COND(&FLD7 *NE '  ' *AND &FLD7 *NE 'NA') THEN(DO)
                        CHGVAR  VAR(%SST(&SELECT 153 4)) VALUE('    ')
                        GOTO     END
                        ENDDO
/**/
             IF         COND(&FLD6 *NE '    ' *AND &FLD6 *NE 'NA') THEN(DO)
                        CHGVAR  VAR(%SST(&SELECT 132 4)) VALUE('    ')
                        GOTO     END
                        ENDDO
/**/
             IF         COND(&FLD5 *NE '  ' *AND &FLD5 *NE 'NA') THEN(DO)
                        CHGVAR  VAR(%SST(&SELECT 109 4)) VALUE('    ')
                        GOTO     END
                        ENDDO
/**/
             IF         COND(&FLD4 *NE '      ') THEN(DO)
                        CHGVAR  VAR(%SST(&SELECT 88 4)) VALUE('    ')
                        GOTO     END
                        ENDDO
/**/
             IF         COND(&FLD3 *NE '   ' *AND &FLD3 *NE 'NA') THEN(DO)
                        CHGVAR  VAR(%SST(&SELECT 63 4)) VALUE('    ')
                        GOTO     END
                        ENDDO
/**/
             IF         COND(&FLD2 *NE '   ' *AND &FLD2 *NE 'NA') THEN(DO)
                        CHGVAR  VAR(%SST(&SELECT 41 4)) VALUE('    ')
                        GOTO     END
                        ENDDO
/**/
             IF         COND(&FLD1 *NE '    ' *AND &FLD1 *NE 'NA') THEN+
                        (CHGVAR  VAR(%SST(&SELECT 19 4)) VALUE('    '))
 
/**/
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
