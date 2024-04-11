      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP ZALIGN Screen Field  Exec User Program')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing data module                                 *
      *                                                               *
      *  GPALIGN - Call to execute ZALIGN subroutine                  *
      *                                                               *
      *  (c) Finastra International Limited 2024                      *
      *                                                               *
      *  Last Amend No. MD062503 *CREATE   Date 11Apr24               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD062503 - Error due to ZALIGN not found                     *
      *                                                               *
      *****************************************************************

      ** Declared variables

     D ZRTN            S              7
     D ZFIELD          S             16
     D ZADEC           S              1  0
     D ZADIG           S              2  0
     D ZAFLD           S             16

      /COPY GPCPYSRCG,GPALIGN1LE

     C     *ENTRY        PLIST
     C                   PARM                    ZRTN
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
     C                   PARM                    ZAFLD

     C                   EVAL      ZRTN = *BLANKS

     C                   EXSR      ZALIGN

     C                   IF        *IN99 = *ON
     C                   EVAL      ZRTN  =  '*ERROR*'
     C                   ELSE
     C                   EVAL      ZAFLD = ZFIELD
     C                   ENDIF

     C                   RETURN

      /COPY GPCPYSRCG,GPALIGN2LE

