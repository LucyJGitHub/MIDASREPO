     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update rcds before and after year 2000')
     F*****************************************************************
     F*                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00072 - This program will read the records in the         *
      *             physical file MGOREFPD and check for entries in   *
      *             CIND. If these fields are blank or contain zero   *
      *             these will be amended to either '1' or '2'        *
      *             depending upon the date.                          *
      *             If the year is less than 72 then it is            *
      *             refering to the next century i.e. incl./after     *
      *             year 2000 and so a '2' will be placed in the      *
      *             appropriate field (CIND) otherwise a '1' will     *
      *             be entered in the field.                          *
      *             The logical files will be updated.                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BG26993             Date 26Jan10              *
      *  Prev Amend No. 113352 *CREATE      Date 29Feb00              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *     BG26993 - Delivery of upgrade programs to core.           *
      *             - Renamed program S11335201.                      *
      *     113352  - Program created for fix 113352.                 *
      *                                                               *
      *****************************************************************
     FMGOREFPD  UP   E             DISK
      *
      /EJECT
     C*****************************************************************
     C*
     C** If KDCENT is blank or contains zero amend and update this
     C** field to either contain '1' or '2' if records are before or
     C** after the year 2000 ( 1900 - 1, 2000 - 2)
     C*
     C     CIND          IFEQ      *ZERO                                        B1
     C     CIND          OREQ      *BLANKS
     C*
     C** Retrieve date and move year from KDVDTP (YYMM1/YYMM2) into YY
     C** Depending on the year amend the KDCENT field accordingly.
     C*
     C                   MOVEL     MGDE          YY                2 0
     C     YY            IFLT      72                                           B2
     C                   MOVE      '2'           CIND
     C                   ELSE
     C                   MOVE      '1'           CIND
     C                   ENDIF                                                  E2
     C*
     C**  Update the FILE MGOREFPD Records.
     C*
     C                   UPDATE    MGOREFD0                             50
     C     *IN50         IFEQ      '1'                                          B3
     C                   SETON                                        U7U8
     C                   ENDIF                                                  E3
     C*
     C                   ENDIF                                                  E1
     C*
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
