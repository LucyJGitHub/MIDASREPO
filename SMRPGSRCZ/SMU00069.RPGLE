     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update records before and after year 2000')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00069 - This program will read the records in the         *
      *             logical files DLMSY1L, DLMSY2L,  and check        *
      *             for entries in KDCENT and KECENT. If these        *
      *             fields are blank or contain zero these will be    *
      *             amended to either '1' or '2' depending upon the   *
      *             date.  If the year is less than 72 then it is     *
      *             refering to the next century i.e. incl./after     *
      *             year 2000 and so a '2' will be placed in the      *
      *             appropriate field (KD/KECENT) otherwise a '1'     *
      *             will be entered in the field.                     *
      *             The logical files will be updated.                *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BG26993            Date 26Jan10               *
      *                 110523             Date 13Dec96               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *     BG26993 - Delivery of upgrade programs to core.           *
      *             - Renamed program S11052301.                      *
      *     110523  - Program created for fix 110523.                 *
      *                                                               *
      *****************************************************************
     FDLMSY1L   UF   E           K DISK
     FDLMSY2L   UF   E           K DISK
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    F U N C T I O N    O F   I N D I C A T O R S               *
      *    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~               *
      *         10         READ  FAIL DLMSY1L                         *
      *         11         READ  FAIL DLMSY2L                         *
      *                                                               *
      *         LR         LAST RECORD INDICATOR                      *
      *                                                               *
      *****************************************************************
      *
     C/EJECT
     C*
     C** Read Logical file DLMSY1L
     C     *LOVAL        SETLL     DLMSY1L
     C                   READ      DLMSY1L                                10
     C*
     C** Do until end of file
     C     *IN10         DOWEQ     '0'
     C*
     C** If KDCENT is blank or contains zero amend and update this
     C** field to either contain '1' or '2' if records are before or
     C** after the year 2000 ( 1900 - 1, 2000 - 2)
     C     KDCENT        IFEQ      *ZERO                                        B1
     C*
     C** Retrieve date and move year from KDVDTP (YYMM1/YYMM2) into YY
     C** Depending on the year amend the KDCENT field accordingly.
     C                   MOVEL     KDVDTP        YY                2 0
     C     YY            IFLT      72                                           B2
     C                   MOVE      '2'           KDCENT
     C                   ELSE
     C                   MOVE      '1'           KDCENT
     C                   ENDIF                                                  E2
     C*
     C**  Update the LOGICAL FILE DLMSY1L records.
     C                   UPDATE    DLMSY1P0
     C*
     C                   ENDIF                                                  E2
     C*
     C** Read the next record
     C                   READ      DLMSY1L                                10
     C*
     C                   ENDDO
     C*
     C*
     C** Read Logical File DLMSY2L
     C     *LOVAL        SETLL     DLMSY2L
     C                   READ      DLMSY2L                                11
     C*
     C** Do until end of logical file
     C     *IN11         DOWEQ     '0'
     C*
     C** If KECENT is blank or contains zero amend and update this
     C** field to either contain '1' or '2' if records are before or
     C** after the year 2000 ( 1900 - 1, 2000 - 2)
     C     KECENT        IFEQ      *ZERO                                        B3
     C*
     C** Retrieve date and move year from KEVDTP (YYMM1/YYMM2) into YY
     C** Depending on the year amend the KECENT field accordingly.
     C                   MOVEL     KEVDTP        YY                2 0
     C     YY            IFLT      72                                           B4
     C                   MOVE      '2'           KECENT
     C                   ELSE
     C                   MOVE      '1'           KECENT
     C                   ENDIF                                                  E4
     C*
     C**  Update the LOGICAL FILE DLMSY2L records.
     C                   UPDATE    DLMSY2P0
     C*
     C                   ENDIF                                                  E3
     C*
     C** Read the next record
     C                   READ      DLMSY2L                                11
     C*
     C                   ENDDO
     C                   SETON                                            LR
     C                   RETURN
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
