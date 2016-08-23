     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Master Messages Reference Utility')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00091 -   This program will read the records in the       *
      *               physical file MGOREFPD and check for entries in *
      *               CIND and CINDV.                                 *
      *               If these fields are blank or contain zero       *
      *               these will be amended to either '1' or '2'      *
      *               depending upon the date.                        *
      *               If the year is less than 72 then it is          *
      *               refering to the next century i.e. incl./after   *
      *               year 2000 and so a '2' will be placed in the    *
      *               appropriate field otherwise a '1' will          *
      *               be entered in the field.                        *
      *               The logical files will be updated.              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *     Last Amend No. BG26993            Date 26Jan10            *
      *     Prev Amend No. 164663             Date 06Sep99            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *     BG26993 - Delivery of upgrade programs to core.           *
      *             - Renamed program S16466301.                      *
      *     164663  - Program amended for fix 164663.                 *
      *               Fill up century field CINDV                     *
      *     113352  - Program created for fix 113352.                 *
      *               Fill up century field CIND                      *
      *****************************************************************
     FMGOREFPD  UP   E             DISK
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    F U N C T I O N    O F   I N D I C A T O R S               *
      *    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~               *
      *****************************************************************
     C*
     C** If CIND is blank or contains zero amend and update this
     C** field to either contain '1' or '2' if records are before or
     C** after the year 2000 ( 1900 - 1, 2000 - 2)
     C*
     C     CIND          IFEQ      *ZERO                                        B1
     C     CIND          OREQ      *BLANKS
     C                   SETON                                          35
     C*
     C** Retrieve date and move year from MGDE into YY
     C** Depending on the year amend the CIND field accordingly.
     C*
     C                   MOVEL     MGDE          YY                2 0
     C     YY            IFLT      72                                           B2
     C                   MOVE      '2'           CIND
     C                   ELSE
     C                   MOVE      '1'           CIND
     C                   ENDIF                                                  E2
     C                   ENDIF
     C** If CINDV is blank or contains zero amend and update this
     C** field to either contain '1' or '2' if records are before or
     C** after the year 2000 ( 1900 - 1, 2000 - 2)
     C*
     C     CINDV         IFEQ      *ZERO
     C     CINDV         OREQ      *BLANKS
     C                   SETON                                          35
     C** Retrieve date and move year from SVDT (YYMMDD) into YY
     C** Depending on the year amend the CINDV field accordingly.
     C*
     C                   MOVEL     SVDT          YY                2 0
     C     YY            IFLT      72
     C                   MOVE      '2'           CINDV
     C                   ELSE
     C                   MOVE      '1'           CINDV
     C                   ENDIF
     C                   ENDIF
     C*
     C**  Update the FILE MGOREFPD Records.
     C*
     C*
     C     *IN35         IFEQ      *ON
     C                   UPDATE    MGOREFD0
     C                   SETOFF                                         35
     C                   ENDIF
     C*
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      * Check to see that *PSSR has not already been called.
     C     *INLR         IFNE      *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
